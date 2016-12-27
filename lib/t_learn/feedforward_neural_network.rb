#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

$LOAD_PATH.push(File::dirname($0)) ;
require "pry"
require "yaml"


#
# ==
#
class FeedForwardNeuralNetwork
  attr_accessor :node_list, :layer_i, :link_list, :node_id, :n
  def initialize()
    @layer_i = 0    #layer iterator
    @node_list = Array.new
    @link_list = Hash.new
    @node_id = 0
    @n = 0.1
  end

  def add_layer(node_num)
    node_array = Array.new()
    node_num.times do |num|
      node = Node.new(0.2)
      node.set_id(@node_id)
      node_array.push(node)
      @node_id += 1
    end

    @node_list.push(node_array)
    # connect link
    if @layer_i != 0  # if not first layer
      # connect link to @layer_i - 1 layer
      connect_nodes
    end
    @layer_i += 1
  end

  #
  # === connect_nodes
  # 
  def connect_nodes
    @node_list[@layer_i - 1].each do |from_node|
      @node_list[@layer_i].each do |to_node|
        @link_list["#{from_node.id}_#{to_node.id}"] = 0.0
      end
    end
  end

  #
  # === 
  #
  # @param x_train Array
  # @param y_train Array
  #
  def fit(x_train, y_train)
    # input teacher_datas
    1000.times do 
      x_train.zip(y_train).each do |x, y|
        propagation(x)
        # back_propagation 
        back_propagation(y)
      end
    end
  end

  def evaluate(x_test, y_test)
    # compare teacher_datas and output of nn
    sum = 0.0
    x_test.zip(y_test).each do |x, y|
      propagation(x)
      @node_list[@layer_i -1].zip(y).each do |output, y_|
          puts "x #{x}, y #{y_} , output #{output.w}"
         if output.w > 0.5
            output.w = 1.0
         else 
            output.w = 0.0
        end
        sum += 1 if output.w == y_
      end
    end 
    return (sum/y_test.size) * 100.0
  end

  #
  # === 入力と伝搬
  #
  def propagation(x)
    # input data 
    @node_list[0].each_with_index do |node, i|
      node.input (x[i])
    end
    @layer_i.times do |layer_num|
      if layer_num != (@layer_i-1)
        # puts "layernum #{layer_num}"
        @node_list[layer_num + 1].each do |to_node|
          sum_all_from_node = 0.0
          @node_list[layer_num].each do |from_node|
            sum_all_from_node += @link_list["#{from_node.id}_#{to_node.id}"] * from_node.w
          end
          to_node.update_w(sum_all_from_node)
        end
      end
    end
  end

  #
  # === 誤差逆伝搬
  # 各リンク毎
  #
  def back_propagation(y)
    delta = {}
    ( @layer_i - 1).downto(1) do |layer_num|
      if ( @layer_i - 1) == layer_num   # if output layer
        @node_list[layer_num].each_with_index do |to_node, i|
          @node_list[layer_num - 1].each do |from_node|
            delta["#{from_node.id}_#{to_node.id}"] = - calc_err(to_node.w,y[i]) * to_node.w * (1.0 - to_node.w)
            # puts "delta[#{from_node}_#{to_node}]  #{delta['#{from_node}_#{to_node}']}"
            delta_weight = -1.0 * @n * delta["#{from_node.id}_#{to_node.id}"] * to_node.w
            @link_list["#{from_node.id}_#{to_node.id}"] = @link_list["#{from_node.id}_#{to_node.id}"] + delta_weight ;
          end
        end
      else 
        @node_list[layer_num].each do |to_node|
          @node_list[layer_num - 1].each do |from_node|
            delta["#{from_node.id}_#{to_node.id}"] = calc_delta(delta,layer_num, to_node) * to_node.w * (1.0 - to_node.w)
            delta_weight = -1.0 * @n * delta["#{from_node.id}_#{to_node.id}"] * to_node.w
            @link_list["#{from_node.id}_#{to_node.id}"] = @link_list["#{from_node.id}_#{to_node.id}"] + delta_weight 
          end
        end
      end
    end
  end

  #
  # === 出力値との誤差を求める
  #
  def calc_err(w, teacher_data)
    return (teacher_data - w )
  end

  #
  # === 上のノード
  #
  def calc_delta(delta,layer_i, from_node)
    sum = 0.0
    @node_list[layer_i+1].each do |to_node|
      sum += delta["#{from_node.id}_#{to_node.id}"] * from_node.w 
    end
    return sum
  end

  class Node
    attr_accessor :w,:active_function, :threshold, :id
    def initialize(w = 0.0, active_function = "sig", threshold = 0.0)
      @w = w 
      @threshold = threshold 
      @active_function = active_function
    end
    
    def set_id(id) 
      @id = id
    end

    # it can use input fase
    def input(w)
      @w = w
    end

    def update_w(input)
      # update by sigmoid
      @w = sigmoid_fun(input)
    end

    #
    # === シグモイド関数で変換した値を返す
    #
    def sigmoid_fun(x, a=1)
      result= (1.0/(1.0+Math.exp(-1.0 * a * x))) ;
      if result.nan?
        binding.pry ;
      end
      return result
    end
  end
end
#
# 実行用
#
if($0 == __FILE__) then
  model = FeedForwardNeuralNetwork.new
  model.add_layer(2)
  model.add_layer(3)
  model.add_layer(1)
  
  # puts "link #{model.link_list}"
  x_train = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
  y_train = [[ 0.0 ], [ 0.0 ],[ 0.0 ],[ 1.0 ]]
  model.fit(x_train, y_train)
  
  test = []

  x_test = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
  y_test = [[ 0.0 ], [ 0.0 ], [ 0.0 ], [ 1.0 ], [0.0], [1.0]]
  score = model.evaluate(x_test, y_test)

  model.node_list.each do |n|
    n.each do |nn|
      # puts nn.w
    end
  end

  # puts model.link_list
  puts "score : #{score}"

  # puts score

end



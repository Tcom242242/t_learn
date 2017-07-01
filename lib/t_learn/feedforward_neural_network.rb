#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

module TLearn
  #
  # ==
  #
  class FNN
    attr_accessor :layer_list, :layer_size, :link_list, :node_id, :learning_rate, :err_list, :threshold
    def initialize(learning_rate=0.1, threshold=0.0, momentum_rate=0.01)
      @layer_size = 0    #layer iterator
      @layer_list = Array.new
      @link_list = Hash.new
      @node_id = 0
      @learning_rate = learning_rate
      @momentum_weight_list = Hash.new
      @momentum_rate = momentum_rate
      @err_list = Array.new
      @threshold = threshold
    end

    def add_layer(node_num)
      node_list = Array.new()
      node_num.times do |num|
        node = Node.new(0.0,"sig", @threshold)
        node.set_id(@node_id)
        node_list.push(node)
        @node_id += 1
      end

      @layer_list.push(node_list)
      # connect link
      if @layer_size != 0  # if not first layer
        # connect link to @layer_size - 1 layer
        connect_nodes
      end
      @layer_size += 1
    end

    #
    # === connect_nodes
    # 
    def connect_nodes
      @layer_list[@layer_size - 1].each do |from_node|
        @layer_list[@layer_size].each do |to_node|
          @link_list["#{from_node.id}_#{to_node.id}"] = rand(-1.0...1.0)
          @momentum_weight_list["#{from_node.id}_#{to_node.id}"] = 0.0
        end
      end
    end

    #
    # === 
    #
    # @param x_train Array
    # @param y_train Array
    #
    def fit(x_train, y_train, epoch)
      # input teacher_datas
      epoch.times do 
        epoch_err = 0.0 
        x_train.zip(y_train).each do |x, y|
          x, y = x_train.zip(y_train).sample
          # puts "x #{x}, y #{y}"
          propagation(x)
          epoch_err += calc_ave_err(y)
          back_propagation(y)
        end
        @err_list.push(epoch_err)
      end
    end

    def propagation(x)
      raise "input size is different from  node num of input layer "  if @layer_list[0].size != x.size
      # input data 
      @layer_list[0].each_with_index do |node, i|
        node.input (x[i])
      end
      @layer_size.times do |layer_num|
        if layer_num != (@layer_size-1)
          # puts "layernum #{layer_num}"
          @layer_list[layer_num + 1].each do |to_node|
            sum_all_from_node = 0.0
            @layer_list[layer_num].each do |from_node|
              sum_all_from_node += @link_list["#{from_node.id}_#{to_node.id}"] * from_node.w
            end
            to_node.update_w(sum_all_from_node + 1.0)
          end
        end
      end

      return get_output_layer 
    end

    def calc_ave_err(y)
      sum_err = 0.0
      @layer_list[@layer_size - 1].each_with_index do |node, i|
        sum_err += calc_err(node.w,y[i]).abs
      end
      ave_err = (sum_err)/y.size
      return ave_err 
    end


    #
    # === 
    # 
    # @param y Array teacher_data
    #
    def back_propagation(y)

      raise "output size different from node num of output layer"  if get_output_layer.size != y.size
      # raise "o"  if get_output_layer.size != y.size
      delta = {}
      ( @layer_size - 1).downto(0) do |layer_num|
        if ( @layer_size - 1) == layer_num   # if output layer
          @layer_list[layer_num].each_with_index do |output_node, i|
            delta["#{output_node.id}"] = -1.0 * calc_err(y[i], output_node.w) * output_node.w * (1.0 -output_node.w)
          end
        else 
          @layer_list[layer_num].each do |from_node|
            # リンクの更新
            @layer_list[layer_num + 1].each do |to_node|
              # モメンタムによる更新
              momentum_weight = @momentum_rate * @momentum_weight_list["#{from_node.id}_#{to_node.id}"]
              update_weight = -1.0 * @learning_rate * delta["#{to_node.id}"] * from_node.w
              @link_list["#{from_node.id}_#{to_node.id}"] = @link_list["#{from_node.id}_#{to_node.id}"] + update_weight + momentum_weight
              @momentum_weight_list["#{from_node.id}_#{to_node.id}"] = update_weight # for momentum
            end
            # その層のdeltaの更新
            delta["#{from_node.id}"] = calc_delta(delta,layer_num, from_node) * from_node.w * (1.0 - from_node.w)
          end
        end
      end
    end

    def calc_err(teacher_data, w)
      return (teacher_data -w)
    end

    def calc_delta(delta,layer_i, from_node)
      sum = 0.0
      @layer_list[layer_i+1].each do |to_node|
        sum += delta["#{to_node.id}"] * @link_list["#{from_node.id}_#{to_node.id}"]
      end
      return sum
    end

    def evaluate(x_test, y_test)
      # compare teacher_datas and output of nn
      sum_err = 0.0
      x_test.zip(y_test).each do |x, y|
        propagation(x)
        output = []
        err = 0.0
        @layer_list[@layer_size -1].zip(y).each do |o, y_f|
          output.push(o.w)
          err += (y_f - o.w).abs
        end
        sum_err += (err/y_test[0].size)
        # puts "x #{x}, y #{y} , output #{output}"
      end 
      return (sum_err/y_test.size) * 100.0
      # return 0.0
    end

    def get_output_layer
      output = []
      @layer_list[@layer_size-1].each do |node|
        output.push(node.w)
      end
      return output
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

      def sigmoid_fun(x, a=1)
        return (1.0/(1.0+Math.exp(-1.0 * a * x)))
      end
    end
  end
end


#
# 実行用
#
if($0 == __FILE__) then
end


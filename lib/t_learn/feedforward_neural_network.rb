#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

module TLearn

  #
  # ==
  #
  class FeedForwardNeuralNetwork
    attr_accessor :layer_list, :layer_size, :link_list, :node_id, :learning_rate
    def initialize(learning_rate=0.3)
      @layer_size = 0    #layer iterator
      @layer_list = Array.new
      @link_list = Hash.new
      @node_id = 0
      @learning_rate = learning_rate
    end

    def add_layer(node_num)
      node_list = Array.new()
      node_num.times do |num|
        node = Node.new(0.2)
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
    def fit(x_train, y_train, epoch)
      # input teacher_datas
      epoch.times do 
        x_train.zip(y_train).each do |x, y|
          propagation(x)
          # back_propagation 
          back_propagation(y)
        end
      end
    end

    def propagation(x)
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
            to_node.update_w(sum_all_from_node)
          end
        end
      end
    end

    #
    # === 
    # 
    # @param y Array teacher_data
    #
    def back_propagation(y)
      delta = {}
      ( @layer_size - 1).downto(1) do |layer_num|
        if ( @layer_size - 1) == layer_num   # if output layer
          @layer_list[layer_num].each_with_index do |to_node, i|
            @layer_list[layer_num - 1].each do |from_node|
              delta["#{from_node.id}_#{to_node.id}"] = - calc_err(to_node.w,y[i]) * to_node.w * (1.0 - to_node.w)
              # puts "delta[#{from_node}_#{to_node}]  #{delta['#{from_node}_#{to_node}']}"
              delta_weight = -1.0 * @learning_rate * delta["#{from_node.id}_#{to_node.id}"] * to_node.w
              @link_list["#{from_node.id}_#{to_node.id}"] = @link_list["#{from_node.id}_#{to_node.id}"] + delta_weight ;
            end
          end
        else 
          @layer_list[layer_num].each do |to_node|
            @layer_list[layer_num - 1].each do |from_node|
              delta["#{from_node.id}_#{to_node.id}"] = calc_delta(delta,layer_num, to_node) * to_node.w * (1.0 - to_node.w)
              delta_weight = -1.0 * @learning_rate * delta["#{from_node.id}_#{to_node.id}"] * to_node.w
              @link_list["#{from_node.id}_#{to_node.id}"] = @link_list["#{from_node.id}_#{to_node.id}"] + delta_weight 
            end
          end
        end
      end
    end

    def calc_err(w, teacher_data)
      return (teacher_data - w )
    end

    def calc_delta(delta,layer_i, from_node)
      sum = 0.0
      @layer_list[layer_i+1].each do |to_node|
        sum += delta["#{from_node.id}_#{to_node.id}"] * from_node.w 
      end
      return sum
    end

    def evaluate(x_test, y_test)
      # compare teacher_datas and output of nn
      sum = 0.0
      x_test.zip(y_test).each do |x, y|
        propagation(x)
        @layer_list[@layer_size -1].zip(y).each do |output, y_|
          puts "x #{x}, y #{y_} , output #{output.w}"
          sum += 1 if output.w == y_
        end
      end 
      return (sum/y_test.size) * 100.0
    end

    class Node
      attr_accessor :w,:active_function, :threshold, :id
      def initialize(w = 0.0, active_function = "sig", threshold = 0.5)
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
        result= (1.0/(1.0+Math.exp(-1.0 * a * x))) ;
        return result
      end
    end
  end
end


#
# 実行用
#
if($0 == __FILE__) then
end


#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

module TLearn

  class HopFieldNet
    attr_accessor :net,:train_datas,:threshold ,:nodes,:dim,:is_train

    def initialize(threshold=nil, data)
      if threshold == nil
        @threshold = 0.0
      else
        @threshold = threshold
      end
      @train_datas=Array.new 
      load_train_data(data)
      @nodes = Array.new(@train_datas[0].length, 1.0)
      @dim = @train_datas[0].length
      @net = Array.new(@dim**2,0.0) 

    end

    def memorize
      @nodes.length.times do |node_id|
        @nodes.length.times do |node2_id|
          sum = 0.0 
          @train_datas.each do |train_data|
            sum += train_data[node_id] * train_data[node2_id] if(node_id != node2_id)
          end
          @net[node_id * @dim + node2_id] = sum
          @net[node2_id*@dim + node_id] = sum
        end
      end
    end

    #
    # ===
    #
    # @param [Array] datas datas which has noise
    #
    def remember(datas)
      @nodes = datas
      e = energy
      loop do
        @nodes.each_with_index do |node,node_id|
          internal_w = calc_connected_factor(node_id) 
          update_external_w(node_id,internal_w)
        end
        new_e = energy
        break if (e == new_e)
        e = new_e
      end
      puts "energy : #{energy}"
    end 

    def calc_connected_factor(target_node_id)
      sum = 0.0
      @nodes.each_with_index do |node,node_id|
        sum += @net[target_node_id*@dim + node_id] * node if (target_node_id != node_id )
      end
      return sum
    end

    def update_external_w(node_id,i_w)
      if i_w >= @threshold
        @nodes[node_id] = 1.0
      else
        @nodes[node_id] = -1.0
      end
    end

    #
    # calc energy function
    #
    def energy
      sum = 0.0
      @nodes.each_with_index do |node,node_id|
        @nodes.each_with_index do |node2,node2_id|
          sum += @net[node2_id*@dim + node_id] * node * node2 if ( node != node2)
        end
      end
      sum2 = 0.0 
      @nodes.each do |node|
        sum2 += @threshold * node 
      end

      result = (-1.0/2.0)*sum + sum2
      return result
    end


    def load_train_data(data)
      @train_datas.push(data)
    end

  end

  #
  # === add noise to sample datas
  # @param data Array data which we want to add noise
  # @param noise_rate float rate of noise
  #
  def TLearn.add_noise_data(data,noise_rate)
    data_with_noise = Marshal.load(Marshal.dump(data))
    data.size.times do |n|
      if rand <= noise_rate
        if data_with_noise[n] == -1.0
          data_with_noise[n] = 1.0
        else
          data_with_noise[n] = -1.0
        end
      end
    end

    return data_with_noise
  end

  #
  # === evaluate predict data with teatcher data
  #
  def TLearn.evaluate(teacher_data,data)
    dominator = 0.0
    molecule = 0.0 
    teacher_data.zip(data).each do |td,d|
      dominator += 1 
      molecule += 1 if td == d
    end

    return (molecule/dominator)*100
  end

end

#
# 
#
if($0 == __FILE__) then
end



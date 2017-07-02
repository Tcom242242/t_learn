#!/usr/bin/ruby
# -*- encoding: utf-8 -*-


require "t_learn"

data = [1.0, 1.0, -1.0, -1.0, 1.0, 1.0, -1.0, -1.0, 1.0, 1.0, 1.0, 1.0, -1.0]  # teacher data
puts "correct data : "+data.to_s
hop_field_net = TLearn::HopFieldNet.new(0.0, data)
hop_field_net.memorize
noise_data = TLearn.add_noise_data(data, 0.2) # make test data
puts "noised data : "+noise_data.to_s
puts "accuracy : #{TLearn.evaluate(data, noise_data)}%"
puts "remember"
hop_field_net.remember(noise_data)
puts "outoput data : "+hop_field_net.nodes.to_s
puts "accuracy : #{ TLearn.evaluate(data,hop_field_net.nodes) }%" 

#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

require "t_learn"

model = TLearn::FNN.new(learning_rate=0.1)

model.add_layer(node_num=2)
model.add_layer(node_num=3)
model.add_layer(node_num=1)

x_train = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
y_train = [[ 0.0 ], [ 1.0 ],[ 1.0 ],[ 0.0 ]]
model.fit(x_train, y_train, epoch=50000)

x_test = x_train
y_test = y_train

err_rate = model.evaluate(x_test, y_test)

puts "err rate: #{err_rate}%"

# p x_test[0]
# model.propagation(x_text[0])
# puts model.get_output_layer[1].w




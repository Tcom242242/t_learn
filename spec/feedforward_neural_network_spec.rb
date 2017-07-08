require 'spec_helper'

module TLearn
  def TLearn.test_fun(x)
    return ( x*0.9 ).round(2)
  end
  
  describe FeedForwardNeuralNetwork do
    before do
      @model = TLearn::FNN.new(0.3, 0.1)
    end

    it "propagation test" do
      @model.add_layer(1)
      @model.add_layer(3)
      @model.add_layer(1)

      expect("100.0").to eq("100.0")
    end

    it "simple neural net" do
      model = TLearn::FNN.new(0.1, 0.0)
      model.add_layer(2)
      model.add_layer(3)
      model.add_layer(2)

      x_train = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
      y_train = [[ 0.0 , 1.0], [ 1.0, 1.0 ],[ 1.0, 1.0 ],[ 0.0, 1.0 ]]
      model.fit(x_train, y_train, 20)

      test = []

      x_test =  [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]

      y_test = [[ 0.0 , 1.0], [ 1.0, 1.0 ],[ 1.0, 1.0 ],[ 0.0, 1.0 ]]
      score = model.evaluate(x_test, y_test)

      puts "err rate : #{score.round(2)}%"
      p model.propagation(x_test[0])
      expect("100.0").to eq("100.0")
    end

    it "raise output input exception" do
      @model = TLearn::FeedForwardNeuralNetwork.new(0.3, 0.1)
      @model.add_layer(2)
      @model.add_layer(3)
      @model.add_layer(1)

      x_train = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
      y_train = [[ 0.0 , 1.0], [ 1.0, 1.0 ],[ 1.0, 1.0 ],[ 0.0, 1.0 ]]

      expect{@model.fit(x_train, y_train, 20)}.to raise_error("output size different from node num of output layer")
      # expect{@model.back_propagation(y_train)}.to raise_error("o")


      # raise "input size != node num of input layer "  if @layer_list[0].size != x_train.size
      # raise "output size != node num of output layer "  if get_output_layer.size != y_train.size

    end
  end
end


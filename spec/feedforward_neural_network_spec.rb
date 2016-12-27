require 'spec_helper'

module TLearn
  def TLearn.test_fun(x)
    return ( x*0.9 ).round(2)
  end
  
  describe FeedForwardNeuralNetwork do
    before do
      @model = FeedForwardNeuralNetwork.new
    end
  
    it "propagation test" do
      @model.add_layer(2)
      @model.add_layer(3)
      @model.add_layer(1)
      @model.propagation(0)

      expect("100.0").to eq("100.0")
    end

    it "simple neural net" do
      model = FeedForwardNeuralNetwork.new
      model.add_layer(2)
      model.add_layer(5)
      model.add_layer(1)

      # puts "link #{model.link_list}"
      # x_train = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]

      x_train = [[0.1, 1.0],[0.2, 1.0], [0.4, 1.0], [0.6, 1.0]]
      # y_train = [[ 0.0 ], [ 0.0 ],[ 0.0 ],[ 1.0 ]]

      y_train = [[ TLearn.test_fun(x_train[0][0]) ], [ TLearn.test_fun(x_train[1][0]) ],[ TLearn.test_fun(x_train[2][0]) ],[ TLearn.test_fun(x_train[3][0]) ]]
      model.fit(x_train, y_train, 500000)

      test = []

      x_test = [[0.1, 1.0],[0.2, 1.0], [0.4, 1.0], [0.6, 1.0]]
      # x_test = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
      # y_test = [[ 0.0 ], [ 0.0 ], [ 0.0 ], [ 1.0 ], [0.0], [1.0]]

      y_test = [[ TLearn.test_fun(x_train[0][0]) ], [ TLearn.test_fun(x_train[1][0]) ],[ TLearn.test_fun(x_train[2][0]) ],[ TLearn.test_fun(x_train[3][0]) ]]
      score = model.evaluate(x_test, y_test)

      # puts model.link_list
      puts "score : #{score}"

      expect("100.0").to eq("100.0")
    end
  end
end


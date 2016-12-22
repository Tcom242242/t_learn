require 'spec_helper'

module TLearn
  describe HopFieldNet do
    it "should do HopFieldNet" do
      data = [1.0, 1.0, -1.0, -1.0, 1.0]
      hopFieldNet = TLearn::HopFieldNet.new(0.0, data)
      hopFieldNet.memorize
      noisedData = TLearn.add_noise_data(data, 0.0)
      puts "======[before]======"
      puts "#{TLearn.evaluate(data, noisedData)}%"
      hopFieldNet.remember(noisedData)
      puts "======[after]======"
      puts "#{ TLearn.evaluate(data, hopFieldNet.nodes) }%" 

      expect("100.0").to eq("#{ TLearn.evaluate(data, hopFieldNet.nodes) }")
    end
  end
end


require 'spec_helper'

module TLearn
  describe K_Means do
    before do
      @k_means = TLearn::K_Means.new()
    end

    it "k_means test" do
      dim, data_num = 2, 200
      datas = data_num.times.map { |t|
        data = dim.times.map { rand()*10 }
      }
      # datas=[[10, 4],[2, 8],[7, 3],[3, 5],[6, 3],[5, 3],[2, 4],[2, 3], [1, 4], [1, 3], [6, 6], [10, 1],[1, 1], [8, 1], [1, 6], [10, 6]]
      # datas=[[2, 3],[2, 8],[2, 3],[3, 5],[6, 3],[5, 3]]
      puts "calculating..."

      datas = JSON.load(open("./spec/sample_1dim.json"))
      result = @k_means.fit(data_list=datas, k=3) 
      puts "finish"
      expect("").to eq("")

    end
  end

end


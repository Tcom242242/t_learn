require 't_learn'

#
# === 混合正規分布を生成する
#
def gaussian_mix_1dim()
  # r = self.normal_rand(0.0,1.0 )
  r = normal_rand(rand(100),rand(100))
  # r = gauusian([rand()*100], [1.0], [[ 2.0 ]])
  # r2 = normal_rand(5.0, 5.0)
  # r3 = normal_rand(20.0, 1.0)
  r2 = normal_rand(rand(100), rand(100))
  # r2 = gauusian([rand()*100], [20.0], [[5.0]])
  # return [0.2*r + 0.8*r2]
  rand = rand()
  if (rand < 0.3)
    return [r]
  else
    return [r2]
  end

  # if (rand < 0.3)
  #   return [r]
  # elsif(rand < 0.5)
  #   return [r2]
  # else
  #   return [r3]
  # end
end

#
# ===ボックス―ミューラー法をよる正規分布乱数発生
# @param mu flout 平均
# @param sigma flout 標準偏差
# @return ボックスミューラー法に従う正規分布に従う乱数を生成
#
def normal_rand(mu = 0,sigma = 1.0)
  a, b = rand(), rand() ;
  return (Math.sqrt(-2*Math.log(rand()))*Math.sin(2*Math::PI*rand()) * sigma) + mu
end

def gaussian_mix_2dim()
    r1_x = self.normal_rand()
    r1_y = self.normal_rand()
    r2_x = self.normal_rand(10.0, 50.0)
    r2_y = self.normal_rand(10.0, 50.0)

      if (rand() < 0.15)
        return [r1_x, r1_y]
      else
        return [r2_x, r2_y]
      end
    end

em= TLearn::EM_Gaussian.new()
data_list = JSON.load(open("./faithful.json"))
# data_list = 100.times.map{|i| gaussian_mix_1dim()}
em.fit(data_list, 2)


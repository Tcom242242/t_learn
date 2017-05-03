#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

require "yaml"

module TLearn
  class K_Means
    attr_accessor 
    
    def initialize
          end
 
    #
    # === make datas for test
    #
    def make_data

    end

    def run
      
    end

    
 
    def calc_burden_ratio(k)
         end    

    def log_likelihood
       
    end 

    def update_mu(k, burden_ratio)
          end

    def update_var(k, burden_ratio)
          end

    def update_pi(k)
    end
    
    #
    # === 混合正規分布を生成する
    #
    def gaussian_mix()
          end


    #
    # === gauusian distribution 
    #
    def gauusian(x, mu, sigma)
      f1 = (1.0/Math.sqrt(2.0*Math::PI))
      f2 = Math.exp(-((x-mu)^2 / 2*sigma^2))
      return f1 * f2
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


  end
end

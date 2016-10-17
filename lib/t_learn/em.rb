#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

require "yaml"

module TLearn
  class EM
    attr_accessor :mu_list, :var_list, :pi_list, :datas, :log_likelihood, :burden_ratio, :k
    , :n
    
    def initialize
      @mu = 0.1
      @var = 0.1
      @pi = 0.1
    end
 
    #
    # === make datas for test
    #
    def make_data

    end

    def run
      # loop until likelihood is converged
        # calc burden_ratio
        # calc e_step
        # calc m_step
        # calc log_likelihood
    end

    def e_step

    end

    def m_step

    end
 
    def burden_ratio
      denominator = 0.0
      @pi_list.each_with_index do |pi, i|
        denominator += normal_rand(@mu_list[i], @var_list[i]) 
      end

      molecule
    end    

    def log_likelihood
       
    end 

    #
    # === 混合正規分布を生成する
    #
    def gaussian_mix()
      r1 = normal_rand()
      r2 = normal_rand(5.0, 2.0)

      if (rand() < 0.5)
        return r1
      else
        return r2
      end
    end


    #
    # === gauusian distribution 
    #
    def gauusian(x, mu, sigma)

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

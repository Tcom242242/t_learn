#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

require "yaml"

module TLearn
  class EM
    attr_accessor :mu_list, :var_list, :pi_list, :datas, :log_likelihood, :burden_ratio, :k_num_
    , :n, :r_list
    
    def initialize
      @data = Array.new(10, 0.0)  # load_data
      @mu_list = Array.new(10, 0.0)
      @var_list = Array.new(10, 0.0)
      @r_list = Array.new(10, 0.0)
      @n_list = Array.new(10, 0.0)
      @k_num = 2
    end
 
    #
    # === make datas for test
    #
    def make_data

    end

    def run
      # loop until likelihood is converged
        # calc burden_ratio
        new_r_list = []
        nn = @r_list.inject(:x)
        @r_list.each_with_index do |r, i|
          new_r_list[i] = calc_burden_ratio(r)
          @mu_list[i] = update_mu(r)
          @var_list[i] = update_var(r)
          @pi_list = update_pi(r, nn)
        end
        @r_list = new_r_list
        # calc log_likelihood

    end

    
 
    def calc_burden_ratio(k)
      denominator = 0.0
      @pi_list.each_with_index do |pi, i|
        denominator += normal_rand(@mu_list[i], @var_list[i]) 
      end

      molecule = @pi_list[k] * gauusian(x, @mu_list[k], @var_list[k])
      
      return molecule/denominator
    end    

    def log_likelihood
       
    end 

    def update_mu(k, burden_ratio)
      sum = 0.0
      @datas.each_with_index do |data, i|
        sum += burden_ratio[i] * data
      end
      return sum/@n_list[k]
    end

    def update_var(k, burden_ratio)
      sum = 0.0
      @datas.each_with_index do |data, i|
        sum += burden_ratio[i] * ( data - @mu_list[k]) * ( data - @mu_list[k])
      end
      return sum/@n_list[k]

    end

    def update_pi(k)
      return @n_list[k]/@k_num
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

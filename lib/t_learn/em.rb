#!/usr/bin/ruby
# -*- encoding: utf-8 -*-

require "yaml"
require "json"
require "pry"

module TLearn

  class EM_Gaussian
    attr_accessor :mu_list, :conv_list, :pi_list, :log_likelihood, :k_num,:data_list, :real_data_list

    def init(data_list, k_num)
      @k_num = k_num # ガウス分布の数
      @data_list = data_list
      @dim = @data_list[0].size
      @data_list = scale(@data_list)
      @real_data_list = Marshal.load(Marshal.dump(@data_list))
      @mu_list = Array.new(@k_num).map{Array.new(@dim, rand())}
      @conv_list = Array.new(@k_num).map{ini_conv()}
      @pi_list = @k_num.times.map{rand()}
      @gamma = Array.new(@data_list.size).map{Array.new(@k_num, 0)}
    end

    def ini_conv
      conv = []
      @dim.times {|i|
        conv.push(make_array(i))
      }
      return conv
    end

    def make_array(i)
      array = []
      @dim.times {|x|
        if i == x 
          array.push(1.0)
        else
          array.push(0.0)
        end
      }
      return array
    end

    def create_log(cycle)
      log = {:cycle => cycle, 
             :mu => @mu_list.clone, 
             :conv => @conv_list.clone, 
             :pi_list => @pi_list.clone}
      return log
    end


    def fit(data_list, k_num)
      init(data_list, k_num)
      result = []
      cycle = 0
      last_likelihood = calc_log_likelihood()
      loop do 
        e_step()
        m_step()
        likelihood = calc_log_likelihood()
        diff = (likelihood - last_likelihood).abs
        last_likelihood = likelihood
        puts "likelihood: #{likelihood}"
        result.push(create_log(cycle))
        cycle += 1
        break if diff < 0.000001
      end
      puts "===================================="
      puts "pi : #{ @pi_list }"
      puts "mu : #{ @mu_list}"
      puts "conv : #{ @conv_list}"
      return result
    end


    def e_step()
      @data_list.each_with_index{|data, n|
        denominator = 0.0
        @k_num.times{|k|
          denominator += @pi_list[k] * gauusian(data, @mu_list[k], @conv_list[k])
        }
        @k_num.times { |k|
          @gamma[n][k] = @pi_list[k] * gauusian(data, @mu_list[k], @conv_list[k]) / denominator
        }
      }
    end

    def m_step()
      @k_num.times {|k|
        nk = 0.0
        @data_list.each_with_index{|data,  n| 
          nk += @gamma[n][k] 
        }

        @mu_list[k] = calc_ave(k, nk) 
        @conv_list[k] = calc_conv(k, nk)
        @pi_list[k] = nk/@data_list.size
      }
    end

    def calc_ave(k, nk) 
      mu = Array.new(@dim)
      @dim.times{|i|
        mu[i] = @data_list.each_with_index.inject(0.0){|sum,(data, n)| 
          sum += @gamma[n][k] * data[i] 
        } / nk

      }
      return mu
    end

    
    def calc_conv(k, nk)
      conv = Array.new(@dim).map{Array.new(@dim, 0)}
      @dim.times{|i|
        @dim.times{|j|
          @data_list.each_with_index{|data, n|
            conv[i][j] += @gamma[n][k] * (data[i]-@mu_list[k][i]) * (data[j]-@mu_list[k][j])
          } 
        }
      }
      conv = conv.map{|arr| arr.map{|v| v/nk}}
      return conv
    end

    def calc_log_likelihood
      log_likelihood = 0.0
      @data_list.each_with_index{|data, i|
        sum = 0.0
        @k_num.times{|k|
          sum += @pi_list[k] * gauusian(data, @mu_list[k], @conv_list[k]) 
        }
        log_likelihood += Math.log(sum)
      }
      return log_likelihood
    end 


    #
    # === 混合正規分布を生成する
    #
    def gaussian_mix()
      r1_x = normal_rand()
      r1_y = normal_rand()
      r2_x = normal_rand(10.0, 50.0)
      r2_y = normal_rand(10.0, 50.0)

      if (rand() < 0.15)
        return [r1_x, r1_y]
      else
        return [r2_x, r2_y]
      end
    end

    #
    # === gauusian distribution 
    #
    def gauusian(x, mu, sigma)
      if @dim <= 1
        x = x[0]
        mu = mu[0]
        sigma = sigma[0][0]
        f1 = 1.0/(Math.sqrt(2.0*Math::PI)*Math.sqrt(sigma))
        f2 = Math.exp(-(((x-mu)**2)/((2.0*sigma))))
        return f1 * f2
      else
        return gauusian2dim(x, mu, sigma)
      end
    end


    #
    # === gauusian distribution .2 dim version
    #
    def gauusian2dim(x, mu, conv)
      x = Matrix[x]
      mu = Matrix[mu]
      conv = Matrix[*conv]
      begin
        f1 = 1.0/(2.0 * Math::PI * ( conv.det**(0.5) ))
        f2 = Math.exp((-1.0/2.0)*((x-mu) * conv.inverse * (x-mu).transpose)[0, 0])
      rescue
        binding.pry ;
      end

      return (f1 * f2)
    end


    def scale(x)
      if x[0].instance_of?(Array)  # check whether x's factor is 1dim or over 2dim
        sum_each_vec = []
        ave_list = []
        std_list = []
        x.each{|vec| 
          vec.each_with_index{|data, i|
            sum_each_vec[i] = (sum_each_vec[i] == nil) ? data : sum_each_vec[i]+data
          }
        }
        x[0].size.times{|i|
          ave_list.push(sum_each_vec[i]/x.size)
        }

        sum_each_vec = []
        x.each{|vec| 
          vec.each_with_index{|data, i|
            sum_each_vec[i] = (sum_each_vec[i] == nil) ? (ave_list[i]-data)**2 : (sum_each_vec[i]+(ave_list[i]-data)**2)
          }
        }
        x[0].size.times{|i|
          std_list.push(Math.sqrt(sum_each_vec[i]/x.size))
        }

        scaled_x = []
        x.each_with_index{|vec, i| 
          scaled_x[i] ||= []
          vec.each_with_index{|data, j|
            scaled_x[i][j] ||= (data-ave_list[j])/std_list[j]
          }
        }
        return scaled_x
      else  # if 1dim
        mu = x.each.inject(0.0){|sum, data| sum+=data}/x.size
        var = (x.each.inject(0.0){|sum, data| sum+=(data-mu)**2}/x.size) 
        std = Math.sqrt(var)
        scaled_x = []
        x.each{|sum,data| 
          scaled_x.push((mu-data)/std)
        } 
        return scaled_x
      end
    end
  end
end

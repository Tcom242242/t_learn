#!/usr/bin/ruby
# -*- encoding: utf-8 -*-


module TLearn
  class K_Means
    attr_accessor :data_list, :k, :c_list

    def init(data_list, k=2)
      @data_list = data_list
      sliced_data_list = @data_list.each_slice(k).to_a
      @dim = data_list[0].size
      @k = k 
      @cluster_list = @k.times.map {|n| Cluster.new(n, nil,sliced_data_list[n] , @dim)}
    end


    def fit(data_list, k)
      init(data_list, k)
      history = []
      loop {
        @cluster_list.each{|c| c.reset_v_list()}
        @data_list.each {|d|
          min_dist = 100000
          min_cluster_id = -1
          @cluster_list.each {|c|
            dist = calc_dist(d, c)
            if dist < min_dist 
              min_cluster_id = c.id 
              min_dist = dist
            end
          }
          @cluster_list[min_cluster_id].add_v(d)
        }

        history.push(format_for_log())
        @cluster_list.each{|c| c.calc_center()}
        break if !change_clusters_center?
      }

      return {:result => format_for_log(), :history => history}
    end

    def format_for_log()
      result = @cluster_list.map {|c| c.format_hash()}
    end

    def calc_dist(v, cluster)
      dist_sum = 0.0
      v.each_with_index { |v_x, i|
        dist_sum += (cluster.vec[i] - v_x).abs
      } 
      return dist_sum/v.size
    end

    def change_clusters_center?()
      @cluster_list.each {|c|
        return true if(c.change_center?) 
      } 
      return false
    end 

    #
    # cluster 
    # cluster has id, vec, and v_list
    #
    class Cluster
      attr_accessor :id, :vec, :v_list, :last_vec

      def initialize(id, vec=nil, v_list=nil, dim=1)
        @id = id
        @v_list= v_list
        @vec = dim.times.map{0.0} if vec == nil
        @dim = dim
        calc_center()
      end

      def calc_center() 
        @last_vec = Marshal.load(Marshal.dump(@vec))
        vec_sum = Array.new
        @v_list.each { |v|
          v.each_with_index { |v_x, i| 
            vec_sum[i] ||= 0.0
            vec_sum[i] += v_x 
          } 
        }
        vec_sum.each_with_index { |new_vec, i| @vec[i] = new_vec/@v_list.size.to_f } 
      end 

      def add_v(v)
        @v_list.push(v)
      end

      def reset_v_list()
        @v_list = []
      end

      def change_center?
        @dim.times { |i|
          return true if @vec[i] != @last_vec[i]
        }
        return false
      end

      def format_hash()
        cluster_hash = {}
        cluster_hash[:id] = @id
        cluster_hash[:vec] = @vec
        cluster_hash[:v_list] = @v_list
        return cluster_hash
      end
    end
  end
end

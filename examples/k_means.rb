require "t_learn"
require "pry"

k_means = TLearn::K_Means.new()
data_list = JSON.load(open("./sample_1dim.json"))
history = k_means.fit(data_list, c=3) # => {result:=> Array, history => Array}
# history[:result][0] => {id=>cluster's number, :vec=>cluster's point, :v_list=> clustered data list}

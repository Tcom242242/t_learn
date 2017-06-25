require "t_learn"

k_means = TLearn::K_Means.new()
data_list = JSON.load(open("./sample_1dim.json"))
history = k_means.fit(data_list)

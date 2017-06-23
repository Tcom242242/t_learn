require 't_learn'

em= TLearn::EM_Gaussian.new()
data_list = JSON.load(open("./faithful.json"))
em.fit(data_list, 2)


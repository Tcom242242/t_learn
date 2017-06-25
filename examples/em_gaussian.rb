require 't_learn'

em = TLearn::EM_Gaussian.new()
data_list = JSON.load(open("./faithful.json"))
history = em.fit(data_list, 2)


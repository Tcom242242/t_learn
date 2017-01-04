# TLearn
This is my hobby machine learning library.
I will add machine learning items.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 't_learn'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install t_learn

## Usage

### simple feedforward_neural_network
respect for keras.

``` ruby

require "t_learn"

model = TLearn::FeedForwardNeuralNetwork.new(learning_rate=0.1)

model.add_layer(node_num=2)
model.add_layer(node_num=3)
model.add_layer(node_num=1)

x_train = [[0.0, 0.0],[0.0, 1.0], [1.0, 0.0], [1.0, 1.0]]
y_train = [[ 0.0 ], [ 1.0 ],[ 1.0 ],[ 0.0 ]]
model.fit(x_train, y_train, epoch=50000)

x_test = x_train
y_test = y_train

err_rate = model.evaluate(x_test, y_test)

puts "err rate: #{err_rate}%"

# p x_test[0]
# model.propagation(x_text[0])
# puts model.get_output_layer[1].w

```

### result
.... 

```

x [0.0,  0.0],  y [0.0] ,  output [0.03286460161620565]
x [0.0,  1.0],  y [1.0] ,  output [0.9733866321804969]
x [1.0,  0.0],  y [1.0] ,  output [0.9731963536942299]
x [1.0,  1.0],  y [0.0] ,  output [0.014481150692655216]
err rate: 2.5190691608533524%

```


### hop filed net
sample
``` ruby

require "t_learn"

data = [1.0, 1.0, -1.0, -1.0, 1.0]  # teacher data
hop_field_net = TLearn::HopFieldNet.new(0.0, data)
hop_field_net.memorize
noisedData = TLearn.add_noise_data(data, 0.0) # make test data
puts "======[before]======"
puts "#{TLearn.evaluate(data, noisedData)}%"
hop_field_net.remember(noisedData)
puts "======[after]======"
puts "#{ TLearn.evaluate(data,hop_field_net.nodes) }%" 

```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/t_learn. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).


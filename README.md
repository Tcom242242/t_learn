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
def test_fun(x)
    return ( x*0.9 ).round(2)
end


model = TLearn::FeedForwardNeuralNetwork.new
model.add_layer(2)
model.add_layer(5)
model.add_layer(1)

x_train = [[0.1, 1.0],[0.2, 1.0], [0.4, 1.0], [0.6, 1.0]]

y_train = [[ test_fun(x_train[0][0]) ], [ test_fun(x_train[1][0]) ],[ test_fun(x_train[2][0]) ],[ test_fun(x_train[3][0]) ]]
model.fit(x_train, y_train, 500000)

x_test = [[0.1, 1.0],[0.2, 1.0], [0.4, 1.0], [0.6, 1.0]]
y_test = [[ test_fun(x_train[0][0]) ], [ test_fun(x_train[1][0]) ],[ test_fun(x_train[2][0]) ],[ test_fun(x_train[3][0]) ]]

model.evaluate(x_test, y_test)

```

### result
.... 

```

x [0.1,  1.0],  y 0.09 ,  output 0.22505163646378912
x [0.2,  1.0],  y 0.18 ,  output 0.2817288022885251
x [0.4,  1.0],  y 0.36 ,  output 0.3699200581887254
x [0.6,  1.0],  y 0.54 ,  output 0.42524180537036876

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


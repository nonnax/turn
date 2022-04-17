simple router for web apps

```ruby
    require './lib/turn'

    App=Turn.new do
      define do
        on '/' do
          get do
            res.write 'hello'
          end
        end
        on '/greet' do 
          get do |params|
            res.write "greetings! #{params}"
          end
        end
        on '/greet/:me' do
          get do 
            res.write "hey you! #{inbox} + #{req.params}" 
          end
        end
        on '/greet/:me/:too' do |me, too| # captured slug values
          get do # |me, too, params| at this point, you get captures plus req.params
            res.write "hey you too! #{me}, #{too} + #{req.params}" 
          end
        end
      end
    end

    run App
```

`inbox` contains match slug captures + req.params

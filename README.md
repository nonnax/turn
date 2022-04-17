simple router for web apps

```ruby
require './lib/turn'

App=Turn.new do
    on '/' do
      get do
        res.write 'hello'
      end
    end
    on '/greet' do 
      get do |params|
        res.write "greetings! #{params}"
      end
      post do |params|
        res.write "posting! #{params}"
      end
    end
    on '/greet/:me' do
      get do 
        res.write "hey you! #{inbox} + #{req.params}" 
      end
    end
    on '/greet/:me/:too' do |me, too|
      get do 
        res.write "hey you too! #{me}, #{too} + #{req.params}" 
      end
    end
    on '/red' do
      res.redirect '/greet/hey'
    end
    # custom 404 handler
    def default
      res.redirect '/greet'
    end
end

run App

```

`inbox` contains match slug captures + req.params

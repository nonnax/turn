simple router for web apps

```ruby
require './lib/turn'

App=Turn.new do
    on '/' do
      get do
        res.write 'GET'
      end
    end
    
    on '/greet' do 
      get do |params| # ?name=X
        res.write "greetings! #{params}"
      end
      post do |params|
        res.write "post! #{params}"
      end
    end
    
    on '/greet/:me' do |name| # captured slug passed to the block
      get do |name, params|   # captured slug + params, for http verbs
        res.write "hey you! #{name} + #{params}" 
      end
    end
    
    on '/greet/:me/:too' do 
      get do 
        # captured slugs go to the inbox
        res.write "hey you too! #{inbox} + #{req.params}" 
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

`inbox` contains matched slug captures + req.params

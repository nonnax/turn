#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:57:34 +0800
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

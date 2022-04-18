#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:57:34 +0800
require './lib/turn'

# use Rack::Static,
  # urls: %w[/css /js /img /media],
  # root: 'public'

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

    on '/erb/:me' do 
      get do |name, params|
        res.erb "hey you! <%=name%> + <%=params%> = <%=inbox%>", 
         inbox:,
         name:, 
         params: 
         # layout: File.read('views/layout.erb')
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

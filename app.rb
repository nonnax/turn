#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:57:34 +0800
require './lib/turn'

App=Turn.new do
    on '/' do
      get do
        res.write 'GET /'
      end
      post do 
        res.write 'POST /'
      end
    end

    on '/red' do
      res.redirect '/erb/turn'
    end

    on '/greet/:me' do |me| # block args, path slugs 
      get do 
       # auto content type as html
        res.html "get: #{me} + #{req.params}" 
      end
      post do 
        res.write "post: #{me} + #{req.params}" 
      end
    end

    on '/erb/:name' do 
      get do |name, params| # local block args, path slugs & req.params
        res.erb "hey <%=name%>, + <%=params%> = <%=inbox%>", 
         inbox:,
         name:, 
         params:, 
         layout: '{ <%=yield%> }'
      end
    end

    # custom 404 handler
    def default
      res.redirect '/'
    end
end


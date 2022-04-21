#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:57:34 +0800
require './lib/turn'

App=Turn do
  on '/' do
    get do
      res.write 'GET /'+String(session[:name])
    end
    post do 
      res.write 'POST /'
    end
  end

  on '/red' do |params|
    session[:name]=(params[:name] || 'turn')
    res.redirect '/erb/'+String(session[:name])
  end

  on '/greet/:me' do  # block args, path slugs 
    get do |me,|
     # auto content type as html
      res.html "get: #{me} + #{req.params}" 
    end
  end
  
  on '/greet/:me/:again' do |me, again| # block args, path slugs 
    get do 
     # auto content type as html
      res.html "get: #{me} #{again} + #{req.params}" 
    end
    post do 
      res.write "post: #{me} + #{req.params}" 
    end
  end

  on '/erb/:name' do 
    get do |name, params| # local block args, path slugs & req.params
      res.erb( "#hey <%=name%>, + query string: <%=params%>, inbox[:name] = <%=inbox[:name]%>", 
       layout: '{ <%=yield%> }',
       inbox:,
       name:, 
       params:, 
       markdown: true,   # parse markdown with kramdown, `markdown`|`md`: true or any
       ) {|s| s.upcase } # kramdown alternative markdown parsing via block. 
    end
  end

  # custom 404 handler
  def default
    res.redirect '/'
  end
end

# add middleware below url mappings definition
App.use Rack::Static,
  urls: %w[/css /js /img /media],
  root: 'public'


simple router for web apps

```ruby
require './lib/turn'

App=Turn.new do
  on '/' do
    get do
      res.write 'GET /'+String(session[:name])
    end
    post do 
      res.write 'POST /'
    end
  end

  on '/red' do
    session[:name]='turn'
    res.redirect '/erb/'+String(session[:name])
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
    res.redirect '/greet'
  end
end

# `use` to add Turn middleware(s) as needed
App.use Rack::Static,
  urls: %w[/css /js /img /media],
  root: 'public'

run App

```

`inbox` contains matched slug captures + req.params

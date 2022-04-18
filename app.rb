#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 16:57:52 +0800
require './lib/turn'

App=Turn.define do
  on '/' do
    get do
      res.write 'GET'
    end
    post do
      res.write 'POST'
    end
  end
  on '/red' do
    res.redirect '/'
  end  
end

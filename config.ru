#!/usr/bin/env ruby
# Id$ nonnax 2022-04-18 17:46:27 +0800
require_relative 'app'
# use Rack::Static,
  # urls: %w[/css /js /img /media],
  # root: 'public'
run App

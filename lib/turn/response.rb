#!/usr/bin/env ruby
# Id$ nonnax 2022-04-18 16:59:42 +0800
require 'kramdown'
class Turn
  # thin wrapper for write method
  class Response < Rack::Response
    def json(s)
      self.headers[Rack::CONTENT_TYPE]='application/json'
      self.write s
    end
    def html(s)
      self.headers[Rack::CONTENT_TYPE]='text/html; charset=utf-8'
      self.write s
    end
    def erb(text, b=binding, **locals, &block)
      _render(text, b, **locals )
      .then{|s| 
         if %i[md markdown].any?{|k|locals.key?(k)}  
          (block ? block.call(s) : Kramdown::Document.new(s).to_html ) 
         else
          s
         end
       }
      .then{|s| locals.key?(:layout) ? _render( locals[:layout], **locals){ s } : s }
      .then{|s| self.html s }      
    end      
    
    private 
    def _render(s, b=binding, **locals)
      new_b=b.dup
      new_b.instance_eval{ locals.each{|k, v|local_variable_set(k, v)}}
      ERB.new(s).result(new_b)
    end
  end
end

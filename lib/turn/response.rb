#!/usr/bin/env ruby
# Id$ nonnax 2022-04-18 16:59:42 +0800
class Turn
  class Response < Rack::Response
    def json(s)
      self.headers[Rack::CONTENT_TYPE]='application/json'
      self.write s
    end
    def html(s)
      self.headers[Rack::CONTENT_TYPE]='text/html; charset=utf-8'
      self.write s
    end
    def erb(s, b=binding, **locals)
      s=_render s, b, **locals
      s=_render( locals[:layout], **locals){ s } if locals.key?(:layout)
      self.html s
    end
    
    private def _render(s, b=binding, **locals)
      new_b=b.dup
      new_b.instance_eval{ locals.each{|k, v|local_variable_set(k, v)}}
      ERB.new(s).result(new_b)
    end
  end
end

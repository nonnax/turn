#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:46:15 +0800
class Turn
  attr :req, :res, :inbox
  def initialize(&block)
    @block=block
    @inbox={}
  end
  def _call(env)
    @req=Rack::Request.new(env)
    @res=Rack::Response.new
    catch(:halt) do
      res.status=200
      instance_eval(&@block)
      default unless @matched
      res.finish
    end
  end
  def call(env)
    dup._call(env)
  end
  def on path
    mdata=req.path_info.match(matcher(path))
    run{ @inbox=@slugs.zip(mdata&.captures || []).to_h; yield inbox.values } if mdata
  end
  def get
    run{ yield inbox.values+req.params.values } if req.get?
  end
  def post
    run{ yield inbox.values+req.params.values } if req.post?
  end
  def put
    run{ yield inbox.values+req.params.values } if req.put?
  end
  def delete
    run{ yield inbox.values+req.params.values } if req.delete?
  end
  def define
    @matched=false
    yield
  end
  def run
    @matched=true
    yield    
  end
  def halt(res)
    throw :halt, res
  end
  def default
    res.status=404
    res.write 'Not Found'
  end
  def matcher(p)
    @slugs = []
    compiled_path = p.dup.gsub(/:\w+/) do |match|
      @slugs << match.gsub(':', '').to_sym
      '([^/?#]+)'
    end
    /^#{compiled_path}\/?$/
  end  
end



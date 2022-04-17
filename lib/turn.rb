#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:46:15 +0800
class Turn
  attr :req, :res, :inbox
  def initialize(&block)
    @block=block
    @inbox={}
  end
  def call(env)
    @req=Rack::Request.new(env)
    @res=Rack::Response.new
    instance_eval(&@block)
    res.finish
  end
  def on path
    mdata=req.path_info.match(matcher(path))
    run{ @inbox=@slugs.zip(mdata&.captures || []).to_h; yield inbox.values } if mdata
  end
  def get
    run{ res.status=202; yield inbox.values+req.params.values } if req.get?
  end
  def post
    run{ res.status=202; yield inbox.values+req.params.values } if req.post?
  end
  def put
    run{ res.status=202; yield inbox.values+req.params.values } if req.put?
  end
  def delete
    run{ res.status=202; yield inbox.values+req.params.values } if req.delete?
  end
  def define
    res.status=404
    yield
  end
  def run
    yield
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



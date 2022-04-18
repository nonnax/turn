#!/usr/bin/env ruby
# Id$ nonnax 2022-04-17 10:46:15 +0800
# a very simple web router
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
      define{ instance_eval(&@block) }
      default unless @matched
      res.finish
    end
  end
  def call(env) dup._call(env) end
  
  def on path
    matched=_matcher(path)
    run{ yield inbox.values } if matched
  end

  def get() run{ yield inbox.values+req.params.values } if req.get? end  
  def post() run{ yield inbox.values+req.params.values } if req.post? end
  def put() run{ yield inbox.values+req.params.values } if req.put? end
  def delete() run{ yield inbox.values+req.params.values } if req.delete? end

  def define() @matched=false; yield end  # starting point
  def run() @matched=true; yield end
  def halt(res) throw :halt, res end # short-circut 
  def default() res.status=404; res.write 'Not Found' end # override as needed
  
  private 
  def _capture(match)
    @inbox=@slugs.zip(Array(match&.captures)).to_h
  end
  def _matcher path
    @slugs = []
    path.dup.gsub(/:\w+/) do |match|
      @slugs << match.gsub(':', '').to_sym
      '([^/?#]+)'
    end
   .then{|p| /^#{p}\/?$/ }
   .then{|p| req.path_info.match(p) }
   .tap{|m| _capture(m) if m }
  end  
end

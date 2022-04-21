#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-04-17 10:46:15 +0800
# a very simple web application router
require_relative 'response'
require 'securerandom'


class Turn
  REGEXP = Hash.new{|h, k| h[k]=%r{\A(#{k})/?\Z} }  
  H = Hash.new{|h, k| h[k]=k.transform_keys(&:to_sym) }  
    
  attr :req, :res, :inbox
  class<<self
    alias _new new
    def new(&block)
      app do
        use Rack::Session::Cookie, secret: SecureRandom.hex(64)
        run Turn._new(&block)
      end
    end
    # `use` Turn.use Middleware
    def use(middleware, *args, **params, &block)
      app.use middleware, *args, **params, &block
    end
    private 
    def app(&block)
      @app ||= Rack::Builder.new(&block)
    end
  end
    
  def initialize(&block)
    @block = block
    @inbox = {}
  end

  def _call(env)
    @req = Rack::Request.new env
    @res = Turn::Response.new
    catch(:halt) do
      define { instance_eval(&@block) }
      default unless @matched
      res.finish
    end
  end

  def call(env)
    dup._call env
  end

  # match user path. on /sample/:id 
  def on(path)
    matched = matcher path
    run { yield(*inbox.values, H[req.params]) } if matched
  end

  def get;    run{|*captures| yield *captures } if req.get? end  
  def post;   run{|*captures| yield *captures } if req.post? end
  def put;    run{|*captures| yield *captures } if req.put? end
  def delete; run{|*captures| yield *captures } if req.delete? end

  def run;  @matched = true;  yield(*inbox.values, H[req.params]) end

  # starting point of cascade
  def define; @matched = false;  yield end

  # short-circut call().
  # any valid rack-spec response or [n, {}, ['']]
  def halt(res) throw :halt, res end

  # default 404 handler. override as needed
  def default; res.status = 404; res.write 'Not Found'  end
  def session; req.session end
  private

  # matches path_info v user path and captures inbox values. 
  # /sample/:id becomes /\A\/(sample/([^/?#]+))\/?\Z/
  # match '/sample/plan' with /\A\/(sample/([^/?#]+))\/?\Z/
  def matcher(path)  
    @slugs = path.scan(/:(\w+)/).flatten.map(&:to_sym)
    path.gsub(/:\w+/, '([^/?#]+)')
        .then { |p| 
          req.path_info.match REGEXP[p] 
        }
        .tap { |m| _capture m }
  end
  def _capture(m)
    path, *vars = m&.captures
    @inbox = @slugs.zip(vars).to_h if path
  end
  # def _regexp(p) %r{\A(#{p})/?\Z} end
end

module Kernel
  def Turn(&block)
    Turn.new(&block)
  end
end

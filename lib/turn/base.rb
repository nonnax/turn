#!/usr/bin/env ruby
# frozen_string_literal: true

# Id$ nonnax 2022-04-17 10:46:15 +0800
# a very simple web application router
require_relative 'response'

class Turn
  attr :req, :res, :inbox

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

  # mounted path matcher
  def on(path)
    matched = matcher path
    run { yield(*inbox.values) } if matched
  end

  def get;    run{|*captures| yield captures } if req.get? end  
  def post;   run{|*captures| yield captures } if req.post? end
  def put;    run{|*captures| yield captures } if req.put? end
  def delete; run{|*captures| yield captures } if req.delete? end

  def run;  @matched = true;  yield(*inbox.values, req.params) end

  # starting point of cascade
  def define; @matched = false;  yield end

  # short-circut call().
  # any valid rack-spec response or [n, {}, ['']]
  def halt(res) throw :halt, res end

  # default 404 handler. override as needed
  def default; res.status = 404; res.write 'Not Found'  end

  private

  # matches path_info and captures inbox values
  def matcher(path)
    @slugs = path.scan(/:(\w+)/).flatten.map(&:to_sym)
    path.gsub(/:\w+/, '([^/?#]+)')
        .then { |p| req.path_info.match(_regexp(p)) }
        .tap { |m| _capture m }
  end
  def _capture(m)
    path, *vars = m&.captures
    @inbox = @slugs.zip(vars).to_h if path
  end
  def _regexp(p) %r{\A(#{p})/?\Z} end
end

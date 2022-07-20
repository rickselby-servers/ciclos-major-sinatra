# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'helpers'

configure do
  set :erb, escape_html: true
  set :sessions, true
  set :show_exceptions, :after_handler if development?
  disable :dump_errors unless development?
  helpers Helpers
end

get('/') { erb :index }

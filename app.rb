# frozen_string_literal: true

require 'rubygems'
require 'bundler'

Bundler.require

require_relative 'helpers'

configure do
  set :erb, escape_html: true
  set :show_exceptions, :after_handler if development?
  disable :dump_errors unless development?
  helpers Helpers
end

error 404 do
  '404: Not found'
end

error do
  error = env['sinatra.error']
  LOGGER.error "#{error.class} - #{error.message}"
  LOGGER.error error.backtrace.join("\n\t")

  'An error occurred - sorry!'
end

get('/') { erb :index }

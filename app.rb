# frozen_string_literal: true

require 'rubygems'
require 'bundler'
require 'logger'

Bundler.require

require_relative 'helpers'

configure do
  set :erb, escape_html: true
  set :show_exceptions, :after_handler if development?
  disable :dump_errors unless development?
  ASSETS = JSON.parse(File.read('public/manifest.json'), symbolize_names: true)
  LOGGER = Logger.new $stdout
  $stdout.sync = true
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
get('/about-us') { erb :todo }
get('/arrivals-and-transfers') { erb :arrivals_and_transfers }
get('/bike-rental') { erb :todo }
get('/contact-us') { erb :todo }
get('/faqs') { erb :todo }
get('/gallery') { erb :todo }
get('/guides') { erb :todo }
get('/lunch-stops') { erb :lunch_stops }
get('/other-information') { erb :todo }
get('/privacy-policy') { erb :todo }
get('/ride-groups') { erb :ride_groups }
get('/routes') { erb :routes }
get('/safety') { erb :safety }
get('/support-crew') { erb :todo }
get('/terms-and-conditions') { erb :todo }
get('/testimonials') { erb :testimonials }

# Camps
get('/camps') { erb :todo }
get('/camps/312') { erb :'camps/312' }
get('/camps/bespoke') { erb :'camps/bespoke' }
get('/camps/cycling-and-triathlon') { erb :'camps/cycling_and_triathlon' }
# Camps booking pages
get('/camps/2022-autumn') { erb :todo }
get('/camps/2023-spring') { erb :todo }
get('/camps/2023-autumn') { erb :todo }
get('/camps/2023-312') { erb :todo }
# Hotels
get('/hotels/can-ribera') { erb :'hotels/can_ribera' }
get('/hotels/zafiro-palace') { erb :'hotels/zafiro_palace' }
get('/hotels/zafiro-tropic') { erb :'hotels/zafiro_tropic' }
# Locations
get('/locations/alcudia') { erb :'locations/alcudia' }
get('/locations/climate') { erb :'locations/climate' }
get('/locations/mallorca') { erb :'locations/mallorca' }
get('/locations/muro') { erb :'locations/muro' }

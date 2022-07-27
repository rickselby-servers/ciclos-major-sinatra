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
get('/about-us') { erb :about_us }
get('/arrivals-and-transfers') { erb :arrivals_and_transfers }
get('/bike-rental') { erb :bike_rental }
get('/contact-us') { erb :todo }
get('/faqs') { erb :faqs }
get('/guides') { erb :guides }
get('/lunch-stops') { erb :lunch_stops }
get('/privacy-policy') { erb :privacy_policy }
get('/ride-groups') { erb :ride_groups }
get('/routes') { erb :routes }
get('/safety') { erb :safety }
get('/support-crew') { erb :support_crew }
get('/terms-and-conditions') { erb :terms_and_conditions }
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

GALLERIES = [
  { slug: '2022-04', name: 'April 2022', cover: '981c2c6c-b6a9-4280-8ddc-a627fd3a474d.jpg' },
  { slug: '2022-04-312', name: '312 April 2022', cover: '61af91b4-464e-4156-a13e-2b0fc1a5bf92.jpg' },
].freeze

get('/gallery') { erb :gallery_index }
get('/gallery/:slug') do
  halt 404 unless GALLERIES.map { |g| g[:slug] }.include? params[:slug]
  @gallery = GALLERIES.find { |g| g[:slug] == params[:slug] }
  erb :gallery
end

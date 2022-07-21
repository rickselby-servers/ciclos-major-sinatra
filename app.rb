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
get('/about-us') { erb :todo }
get('/arrivals-and-transfers') { erb :todo }
get('/bike-rental') { erb :todo }
get('/contact-us') { erb :todo }
get('/faqs') { erb :todo }
get('/gallery') { erb :todo }
get('/guides') { erb :todo }
get('/lunch-stops') { erb :todo }
get('/other-information') { erb :todo }
get('/privacy-policy') { erb :todo }
get('/ride-groups') { erb :todo }
get('/routes') { erb :todo }
get('/safety') { erb :todo }
get('/support-crew') { erb :todo }
get('/terms-and-conditions') { erb :todo }
get('/testimonials') { erb :todo }

# Camps
get('/camps') { erb :todo }
get('/camps/312') { erb :todo }
get('/camps/bespoke') { erb :todo }
get('/camps/cycling-and-triathlon') { erb :todo }
# Camps booking pages
get('/camps/2022-autumn') { erb :todo }
get('/camps/2023-spring') { erb :todo }
get('/camps/2023-autumn') { erb :todo }
get('/camps/2023-312') { erb :todo }
# Hotels
get('/hotels/can-ribera') { erb :todo }
get('/hotels/zafiro-palace') { erb :todo }
get('/hotels/zafiro-tropic') { erb :todo }
# Locations
get('/locations/alcudia') { erb :todo }
get('/locations/climate') { erb :todo }
get('/locations/mallorca') { erb :todo }
get('/locations/muro') { erb :todo }

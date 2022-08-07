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

  enable :sessions
  set :session_secret, ENV.fetch('SESSION_SECRET') { SecureRandom.hex(64) }
  use OmniAuth::Builder do
    if development?
      provider :developer, fields: [:name], uid_field: :name
    else
      provider :microsoft_graph, ENV.fetch('AZURE_APPLICATION_CLIENT_ID', nil),
               ENV.fetch('AZURE_APPLICATION_CLIENT_SECRET', nil)
    end
  end
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
get('/contact-us') { erb :contact }
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
get('/camps/312') { erb :'camps/312' }
get('/camps/bespoke') { erb :'camps/bespoke' }
get('/camps/cycling-and-triathlon') { erb :'camps/cycling_and_triathlon' }
# Camps booking pages
get('/camps/2022-autumn') { erb :'camps/2022-aut' }
get('/camps/2023-spring') { erb :'camps/2023-spr' }
get('/camps/2023-autumn') { erb :'camps/2023-aut' }
get('/camps/2023-312') { erb :'camps/2023-312' }
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
  { slug: '2022-03', name: 'March 2022', cover: '73749231-A772-4D7E-90ED-175637017F2E.jpg' },
  { slug: '2022-02', name: 'February 2022', cover: 'aaccc925-3e98-4661-957c-be050dafb4a6.jpg' },
  { slug: '2021-10-struggle', name: 'The Struggle Week October 2021', cover: 'VRJH3343.jpg' },
  { slug: '2021-10-vc-norwich', name: 'Autumn 2021 - VC Norwich', cover: '062d2e05-41d3-46ce-a519-946d4f81d8f0.jpg' },
  { slug: '2021-09', name: 'Autumn 2021', cover: '281dad1e-4a88-4829-b1ff-a7d36a81a863.jpg' },
  { slug: '2020-02-broughton', name: 'Broughton Cycling Group - February 2020', cover: '3.jpg' },
  { slug: '2020-02-half-term', name: 'Half Term - February 2020', cover: '2.jpg' },
  { slug: '2020-02-evesham', name: 'Evesham Wheelers - February 2020', cover: '3.jpg' },
  { slug: '2020-02-pro-cycle', name: 'Pro Cycle Hire - February 2020', cover: '2.jpg' },
  { slug: '2019-06', name: 'NEC Cycle Show 2019', cover: 'GO Draw Crop.jpg' },
  { slug: '2019-09', name: 'De Ver Cycles - September 2019', cover: 'DVCP 3.jpg' }
].freeze

get('/gallery') { erb :gallery_index }
get('/gallery/:slug') do
  halt 404 unless GALLERIES.map { |g| g[:slug] }.include? params[:slug]
  @gallery = GALLERIES.find { |g| g[:slug] == params[:slug] }
  erb :gallery
end

# Omniauth

get('/login') { erb :login }

get '/auth/:provider/callback' do
  p request.env['omniauth.auth']
  session[:user] = request.env['omniauth.auth']['info']['name']
  redirect '/admin'
end

if development?
  post '/auth/developer/callback' do
    session[:user] = request.env['omniauth.auth']['info']['name']
    redirect '/admin'
  end
end

post '/logout' do
  session.destroy
  redirect '/'
end

# Admin pages

before '/admin/?*' do
  halt 404 unless logged_in?
end

get('/admin') { erb :admin }

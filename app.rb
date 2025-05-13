# frozen_string_literal: true

require "rubygems"
require "bundler"
require "logger"

Bundler.require

require_relative "helpers"

DEV_SECRET = "0fe07dcd4c857ba8dcb8f060c1e8ebf65694fea2a1371b6e5e4b49534725df2f"
SOLD_OUT_312 = true
REGISTER_INTEREST_312 = false

configure do
  Sequel.extension :core_extensions, :migration

  set :erb, escape_html: true
  set :show_exceptions, :after_handler if development?
  disable :dump_errors unless development?
  ASSETS = JSON.parse(File.read("public/manifest.json"), symbolize_names: true)
  DB = Sequel.sqlite("#{production? ? "/database/" : ""}text.db")
  LOGGER = Logger.new $stdout
  $stdout.sync = true
  helpers Helpers

  enable :sessions
  set :session_secret, development? ? DEV_SECRET : ENV.fetch("SESSION_SECRET") { SecureRandom.hex(64) }
  use OmniAuth::Builder do
    if development?
      provider :developer, fields: %i[name], uid_field: :name
    else
      provider :microsoft_graph, ENV.fetch("AD_CLIENT_ID", nil), ENV.fetch("AD_CLIENT_SECRET", nil), client_options: {
        site:          "https://login.microsoftonline.com/",
        token_url:     "#{ENV.fetch("AD_TENANT", nil)}/oauth2/v2.0/token",
        authorize_url: "#{ENV.fetch("AD_TENANT", nil)}/oauth2/v2.0/authorize",
      }
    end
  end

  Sequel::Migrator.run DB, "migrations"
  set :text, nil
end

error 404 do
  erb :"404"
end

error 410 do
  erb :"410"
end

error do
  error = env["sinatra.error"]
  LOGGER.error "#{error.class} - #{error.message}"
  LOGGER.error error.backtrace.join("\n\t")

  "An error occurred - sorry!"
end

before do
  settings.set :text, all_text if settings.text.nil?
end

get("/") { erb :index }
get("/about-us") { erb :about_us }
get("/arrivals-and-transfers") { erb :arrivals_and_transfers }
get("/bike-rental") { erb :bike_rental }
get("/contact-us") { erb :contact }
get("/faqs") { erb :faqs }
get("/guides") { erb :guides }
get("/lunch-stops") { erb :lunch_stops }
get("/privacy-policy") { erb :privacy_policy }
get("/ride-groups") { erb :ride_groups }
get("/routes") { erb :routes }
get("/safety") { erb :safety }
get("/terms-and-conditions") { erb :terms_and_conditions }
get("/testimonials") { erb :testimonials }
get("/videos") { erb :videos }

# Camps
get("/camps/312") { erb :"camps/312" }
get("/camps/bespoke") { erb :"camps/bespoke" }
get("/camps/cycling-and-triathlon") { erb :"camps/cycling_and_triathlon" }
# Camps booking pages
get("/camps/2022-autumn") { halt 410 }
get("/camps/2023-spring") { erb :"camps/2023-spr" }
get("/camps/2023-autumn") { erb :"camps/2023-aut" }
get("/camps/2023-312") { erb :"camps/2023-312" }
get("/camps/2024-spring") { erb :"camps/2024-spr" }
get("/camps/2024-autumn") { erb :"camps/2024-aut" }
get("/camps/2024-312") { erb :"camps/2024-312" }
get("/camps/2025-spring") { erb :"camps/2025-spr" }
get("/camps/2025-autumn") { erb :"camps/2025-aut" }
get("/camps/2025-312") { erb :"camps/2025-312" }
get("/camps/2025-swim") { erb :"camps/2025-swim" }
# Hotels
get("/hotels/can-ribera") { erb :"hotels/can_ribera" }
get("/hotels/zafiro-palace") { erb :"hotels/zafiro_palace" }
get("/hotels/zafiro-tropic") { erb :"hotels/zafiro_tropic" }
# Locations
get("/locations/alcudia") { erb :"locations/alcudia" }
get("/locations/climate") { erb :"locations/climate" }
get("/locations/mallorca") { erb :"locations/mallorca" }
get("/locations/muro") { erb :"locations/muro" }

GALLERIES = [
  { slug: "2025-04-312", name: "312 April 2025", cover: "91365393-2bfc-4032-980c-ceb106f6328a.jpg" },
  { slug: "2025-04", name: "April 2025", cover: "283dd4df-ea9b-40c9-94e6-7ad58bf2fcf6.jpg" },
  { slug: "2025-03", name: "March 2025", cover: "6148c608-e4f0-43bb-8f04-b52f93d57618.jpg" },
  {
    slug:  "2025-03-london-phoenix",
    name:  "London Phoenix March 2025",
    cover: "4fc05ae3-587d-4b3c-b7bb-066d2eaa3646.jpg",
  },
  { slug: "2025-03-tri-camp", name: "Triathlon Camp March 2025", cover: "55758f72-9618-40b7-a31f-74bcdada5c4d.jpg" },
  { slug: "2025-02-lvycc", name: "Lee Valley Week 2025", cover: "669dca28-22c5-4c31-b605-753ec91336b2.jpg" },
  { slug: "2025-02", name: "February 2025", cover: "f3b248e4-bc32-4cd3-bad3-07f766b491fa.jpg" },
  { slug: "2024-05", name: "May 2024", cover: "7e6319e4-1e8a-4a34-b7b4-b77a2949d3e5.jpg" },
  { slug: "2024-04-312", name: "312 April 2024", cover: "cee0c03c-b849-47d7-b7db-a2697058a62d.jpg" },
  { slug: "2024-04", name: "April 2024", cover: "IMG_5476.jpg" },
  { slug: "2024-03", name: "March 2024", cover: "b46869cf-a284-4964-a8af-8195d93aaded.jpg" },
  { slug: "2024-02-lvycc", name: "Lee Valley Week 2024", cover: "aa1f7afe-695d-4b0e-9690-d8b24c53b728.jpg" },
  { slug: "2024-02", name: "February 2024", cover: "5a40f761-0073-4155-8907-1e6b7c680344.jpg" },
  { slug: "2023-10", name: "Autumn 2023", cover: "259381d9-9548-4ecb-b361-ca5a73415557.jpg" },
  { slug: "2023-05", name: "May 2023", cover: "IMG_6846.jpg" },
  { slug: "2023-04", name: "April 2023", cover: "4fe58cc1-8ad7-4c44-ae8e-c3217c090e09.jpg" },
  { slug: "2023-04-312", name: "312 April 2023", cover: "IMG_5014.jpg" },
  { slug: "2023-03", name: "March 2023", cover: "b97c5fd1-39d1-468c-b034-047caeb92b49.jpg" },
  { slug: "2023-02", name: "February 2023", cover: "6f04d102-20fa-46e3-af49-d0c0f9dc98ce.jpg" },
  { slug: "2023-02-lee-valley", name: "Lee Valley Week 2023", cover: "0583e50d-3a60-41ae-a29f-0bbeadad008d.jpg" },
  { slug: "2022-09", name: "Autumn 2022", cover: "eca14a66-19c4-49a7-947e-103c011a3261.jpg" },
  { slug: "2022-04", name: "April 2022", cover: "981c2c6c-b6a9-4280-8ddc-a627fd3a474d.jpg" },
  { slug: "2022-04-312", name: "312 April 2022", cover: "61af91b4-464e-4156-a13e-2b0fc1a5bf92.jpg" },
  { slug: "2022-03", name: "March 2022", cover: "73749231-A772-4D7E-90ED-175637017F2E.jpg" },
  { slug: "2022-02", name: "February 2022", cover: "aaccc925-3e98-4661-957c-be050dafb4a6.jpg" },
  { slug: "2021-10-struggle", name: "The Struggle Week October 2021", cover: "VRJH3343.jpg" },
  { slug: "2021-10-vc-norwich", name: "Autumn 2021 - VC Norwich", cover: "062d2e05-41d3-46ce-a519-946d4f81d8f0.jpg" },
  { slug: "2021-09", name: "Autumn 2021", cover: "281dad1e-4a88-4829-b1ff-a7d36a81a863.jpg" },
  { slug: "2020-02-broughton", name: "Broughton Cycling Group - February 2020", cover: "3.jpg" },
  { slug: "2020-02-half-term", name: "Half Term - February 2020", cover: "3.jpg" },
  { slug: "2020-02-evesham", name: "Evesham Wheelers - February 2020", cover: "3.jpg" },
  { slug: "2020-02-pro-cycle", name: "Pro Cycle Hire - February 2020", cover: "2.jpg" },
  { slug: "2019-06", name: "NEC Cycle Show 2019", cover: "GO Draw Crop.jpg" },
  { slug: "2019-09", name: "De Ver Cycles - September 2019", cover: "DVCP 3.jpg" },
].freeze

get("/gallery") { erb :gallery_index }
get("/gallery/:slug") do
  halt 404 unless GALLERIES.map { |g| g[:slug] }.include? params[:slug]
  @gallery = GALLERIES.find { |g| g[:slug] == params[:slug] }
  erb :gallery
end

get("/press") do
  @press = [
    { slug: "cyclist-apr-2025", name: "The Cyclist – April 2025" },
  ]
  erb :press
end

# Redirects

get("/312-mallorca/?") { redirect "/camps/312" }
get("/about-us/") { redirect "/about-us" }
get("/about-us/ride-leaders/?") { redirect "/guides" }
get("/about-us/support-crew/?") { redirect "/support-crew" }
get("/bike-rental-in-mallorca/?") { redirect "/bike-rental" }
get("/camps/?") { redirect "/" }
get("/camps/bespoke-camps/?") { redirect "/camps/bespoke" }
get("/camps/cycling-and-triathlon/") { redirect "/camps/cycling_and_triathlon" }
get("/contact-us/") { redirect "/contact-us" }
get("/gallery/") { redirect "/gallery" }
get("/hotels-and-locations/?") { redirect "/" }
get("/hotels-and-locations/alcudia/?") { redirect "/locations/alcudia" }
get("/hotels-and-locations/arrivals-and-transfers/?") { redirect "/arrivals-and-transfers" }
get("/hotels-and-locations/can-ribera-rural-hotel-by-zafiro-muro/?") { redirect "/hotels/can-ribera" }
get("/hotels-and-locations/climate/?") { redirect "/locations/climate" }
get("/hotels-and-locations/mallorca/?") { redirect "/locations/mallorca" }
get("/hotels-and-locations/muro/?") { redirect "/locations/muro" }
get("/hotels-and-locations/zafiro-palace/?") { redirect "/hotels/zafiro-palace" }
get("/hotels-and-locations/zafiro-tropic/?") { redirect "/hotels/zafiro-tropic" }
get("/other-information/privacy-policy/?") { redirect "/privacy-policy" }
get("/other-information/tcs/?") { redirect "/terms-and-conditions" }
get("/riding-groups-and-routes/?") { redirect "/" }
get("/riding-groups-and-routes/lunch-stops/?") { redirect "/lunch-stops" }
get("/riding-groups-and-routes/our-routes/?") { redirect "/routes" }
get("/riding-groups-and-routes/ride-groups/?") { redirect "/ride-groups" }
get("/riding-groups-and-routes/safety/?") { redirect "/safety" }
get("/testimonials/") { redirect "/testimonials" }

# Omniauth

get("/login") { erb :login }

get "/auth/:provider/callback" do
  session[:user] = request.env["omniauth.auth"]["info"]["name"]
  # request.env['omniauth.auth']['info']['email']
  # request.env['omniauth.auth']['uid']
  redirect "/"
end

get "/auth/failure" do
  @message = params[:message]
  halt 403, erb(:auth_failure)
end

if development?
  post "/auth/developer/callback" do
    session[:user] = request.env["omniauth.auth"]["info"]["name"]
    redirect "/"
  end
end

post "/logout" do
  session.destroy
  redirect "/"
end

# Admin pages

before "/admin/?*" do
  halt 404 unless logged_in?
end

post "/admin/text" do
  params.each do |k, v|
    DB.transaction do
      if DB[:text_history].where(key: k, current: true, text: v).empty?
        DB[:text_history].where(key: k).update(current: false)
        DB[:text_history].insert(key: k, text: v, person: session[:user])
      end
    end
  end
  settings.set :text, nil
  redirect back
end

get "/admin/history" do
  @keys = DB[:text_history].distinct.order(:key).select_map(:key)
  erb :"admin/keys"
end

get "/admin/history/:key" do
  @history = DB[:text_history].where(key: params[:key]).order(:datetime.desc).all
  erb :"admin/history"
end

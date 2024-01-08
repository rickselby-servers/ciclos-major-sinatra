# frozen_string_literal: true

require "rubygems"
require "bundler/setup"
require_relative "lib/rake_helpers"

Bundler.setup
Bundler.require(:development, :test)

require "rspec/core/rake_task"
RSpec::Core::RakeTask.new(:spec)

require "rubocop/rake_task"
RuboCop::RakeTask.new

require "bundler/audit/task"
Bundler::Audit::Task.new

desc "Bring up app"
task :up do
  system "rerun --background --no-notify -- ruby app.rb -p 8080"
end

desc "Get project ready for dev work"
task init: %i[npm:install webpack]

desc "Build and run production image"
task :prod do
  Rake::Task["npm:install"].invoke
  Rake::Task["webpack:prod"].invoke
  sh "docker build -f docker/Dockerfile -t ciclos-major-prod ."
  sh "docker run -p 80:80 ciclos-major-prod"
end

namespace :npm do
  desc "Run npm ci"
  task :ci do
    sh RakeHelpers.node_command "npm ci"
  end

  desc "Run npm install"
  task :install do
    sh RakeHelpers.node_command "npm install"
  end

  desc "Run npm update"
  task :update do
    sh RakeHelpers.node_command "npm update"
  end
end

desc "Run webpack for dev"
task :webpack do
  sh RakeHelpers.node_command "npx webpack --config webpack.dev.js"
end

namespace :webpack do
  desc "Run webpack watch"
  task :watch do
    sh RakeHelpers.node_command "npx webpack watch --config webpack.dev.js"
  end

  desc "Run webpack production"
  task :prod do
    sh RakeHelpers.node_command "npx webpack --config webpack.prod.js"
  end
end

namespace :resize do
  desc "Resize gallery images"
  task :gallery, [:directory] do |_, args|
    RakeHelpers.resize_photos "public/img/gallery/#{args.directory}", "420x"
  end

  desc "Resize carousel images"
  task :carousel, [:directory] do |_, args|
    RakeHelpers.resize_photos "public/img/carousel/#{args.directory}", "x400"
  end

  desc "Resize guide images"
  task :guides do
    RakeHelpers.resize_photos "public/img/guides", "200x"
  end
end

# frozen_string_literal: true

require 'rubygems'
require 'bundler/setup'

Bundler.setup
Bundler.require(:development, :test)

require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec)

require 'rubocop/rake_task'
RuboCop::RakeTask.new

require 'bundler/audit/task'
Bundler::Audit::Task.new

desc 'Bring up app'
task :up do
  system 'rerun --background --no-notify -- ruby app.rb -p 8080'
end

desc 'Build and run production image'
task :prod do
  Rake::Task['npm:install'].invoke
  Rake::Task['webpack:prod'].invoke
  sh 'docker build -f docker/Dockerfile -t ciclos-major-prod .'
  sh 'docker run -p 80:80 ciclos-major-prod'
end

def node_command(command, name: nil)
  flags = [
    '--rm',
    '-i',
    "-v #{Dir.pwd}:/app",
    '-w /app',
    '--env HOME=./.node',
    "--user #{Process.uid}:#{Process.gid}"
  ]
  flags.push "--name #{name}" unless name.nil?

  "docker run #{flags.join ' '} node:16-alpine #{command}"
end

namespace :npm do
  desc 'Run npm install'
  task :install do
    sh node_command 'npm install'
  end

  desc 'Run npm update'
  task :update do
    sh node_command 'npm update'
  end
end

desc 'Run webpack for dev'
task :webpack do
  sh node_command 'npx webpack --config webpack.dev.js'
end

namespace :webpack do
  desc 'Run webpack watch'
  task :watch do
    sh node_command 'npx webpack watch --config webpack.dev.js'
  end

  desc 'Run webpack production'
  task :prod do
    sh node_command 'npx webpack --config webpack.prod.js'
  end
end

desc 'Resize gallery thumbnails'
task :resize, [:directory] do |_, args|
  FileUtils.cd "public/img/gallery/#{args.directory}/thumb" do
    sh 'pwd'
    sh %(find . -name "*.JPG" -exec bash -c 'mv "$0" "${0%.JPG}.jpg"' {} \\;)
    sh 'mogrify -auto-orient *'
    sh 'mogrify -resize 420x *'
    sh 'git add *'
  end
end

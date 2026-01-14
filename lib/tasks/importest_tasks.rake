# frozen_string_literal: true

module Importest
  RUNTIMES = %i[deno].freeze
  module Tasks
    module_function

    def run_importest_install_template(directory)
      if Rails.root.join('config/importmap.rb').exist?
        system RbConfig.ruby, './bin/rails', 'app:template',
               "LOCATION=#{File.expand_path("../install/#{directory}/importest.rb", __dir__)}"
      else
        puts 'You must be running with importmap-rails (config/importmap.rb) to use this gem.'
      end
    end
  end
end

namespace :importest do
  desc 'Install Importest into the app (runtime=deno, defaults to deno)'
  task :install do |_t, args|
    runtime = (args[:runtime] || 'deno').to_sym

    unless Importest::RUNTIMES.include?(runtime)
      puts "Invalid runtime: #{runtime}. Must be one of: #{Importest::RUNTIMES.join(', ')}"
      exit 1
    end
    Rake::Task["importest:install:#{runtime}"].invoke
  end

  namespace :install do
    desc 'Install Importest on an app running deno'
    task :deno do
      Importest::Tasks.run_importest_install_template 'deno'
    end
  end
end

require 'rails/commands/server/server_command'

namespace :test do
  desc 'Run JavaScript tests'
  task js: :environment do
    runtime = Importest.configuration.runtime

    unless Importest::RUNTIMES.include?(runtime)
      puts "Invalid runtime: #{runtime}. Must be one of: #{Importest::RUNTIMES.join(', ')}"
      exit 1
    end

    host = 'localhost'
    port = 3001
    base_url = "http://#{host}:#{port}"
    importmap = JSON.parse(Rails.application.importmap.to_json(resolver: ActionController::Base.helpers))
    importmap['imports'].transform_values! { |v| v.start_with?('http') ? v : base_url + v }
    server = Rails::Server.new(
      Port: port,
      Host: host,
      environment: 'test',
      server: nil, # nil = auto-detect server
      config: 'config.ru',
      Silent: true
    )
    server_thread = Thread.new { server.start }
    Tempfile.create(['importmap', '.json']) do |f|
      f.write(importmap.to_json)
      f.flush
      system(runtime.to_s, 'test', "--importmap=#{f.path}", '--allow-import')
    end

    server_thread.kill
    server_thread.join
  end
end

# frozen_string_literal: true

require 'fileutils'

namespace :importest do
  desc 'Install Importest into the app (runtime=deno|node, defaults to deno)'
  task :install do
    Rake::Task['importest:install:deno'].invoke
  end

  namespace :install do
    desc 'Install Importest for deno'
    task :deno do
      if Rails.root.join('config/importmap.rb').exist?
        system RbConfig.ruby, './bin/rails', 'app:template',
               "LOCATION=#{File.expand_path('../install/deno/importest.rb', __dir__)}"
      else
        puts 'You must be running with importmap-rails (config/importmap.rb) to use this gem.'
      end
    end

    desc 'Install Importest for node'
    task :node do
      if Rails.root.join('config/importmap.rb').exist?
        system RbConfig.ruby, './bin/rails', 'app:template',
               "LOCATION=#{File.expand_path('../install/node/importest.rb', __dir__)}"
      else
        puts 'You must be running with importmap-rails (config/importmap.rb) to use this gem.'
      end
    end
  end

  desc 'Export importmap to tmp/importmap.json with local file:// URLs'
  task export: :environment do
    tmp_dir = Rails.root.join('tmp/importmap_modules')
    FileUtils.mkdir_p(tmp_dir)

    exports = Rails.application.importmap.packages.transform_values do |package|
      path = package.path
      next path if path.start_with?('http://', 'https://')

      logical_path = path.delete_prefix('/')
      asset_path = find_asset_path(logical_path)
      unless asset_path
        warn "Warning: Could not find asset at #{logical_path}"
        next path
      end

      dest = tmp_dir.join(logical_path.delete_prefix('assets/'))
      FileUtils.mkdir_p(dest.dirname)
      FileUtils.cp(asset_path, dest)
      "file://#{dest}"
    end

    importmap_path = Rails.root.join('tmp/importmap.json')
    File.write(importmap_path, { 'imports' => exports }.to_json)
    puts importmap_path
  end

  def find_asset_path(logical_path)
    assets = Rails.application.assets

    if defined?(Propshaft) && assets.is_a?(Propshaft::Assembly)
      asset = assets.load_path.find(logical_path)
      asset&.path&.to_s
    else
      # Sprockets
      asset = assets.find_asset(logical_path)
      asset&.filename&.to_s
    end
  end
end

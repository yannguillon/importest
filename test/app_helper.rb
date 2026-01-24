# frozen_string_literal: true

require 'English'
require 'rails'
require 'rails/test_help'
require 'fileutils'

module RailsAppHelpers
  private

  def create_new_rails_app(app_dir, options = [])
    require 'rails/generators/rails/app/app_generator'
    Rails::Generators::AppGenerator.start([app_dir, *options, '-GMOC', '--skip-bundle', '--skip-bootsnap', '--quiet'])

    Dir.chdir(app_dir) do
      gemfile = File.read('Gemfile')
      gemfile.gsub!(/^gem ["']importest["'].*/, '')
      gemfile << %(gem "importest", path: #{File.expand_path('..', __dir__).inspect}\n)
      File.write('Gemfile', gemfile)
      run_command('bundle', 'install')
    end
  end

  def with_new_rails_app(options = [], &block)
    require 'digest/sha1'
    variant = [RUBY_VERSION, Gem.loaded_specs['rails'].full_gem_path]
    app_name = "importest_test_app_#{Digest::SHA1.hexdigest(variant.to_s)}"

    Dir.mktmpdir do |tmpdir|
      create_new_rails_app("#{tmpdir}/#{app_name}", *options)
      Dir.chdir("#{tmpdir}/#{app_name}", &block)
    end
  end

  def run_command(*command)
    Bundler.with_unbundled_env do
      stdout, stderr = capture_subprocess_io do
        system(*command)
      end
      exit_code = $CHILD_STATUS.exitstatus
      [exit_code, stdout, stderr]
    end
  end
end

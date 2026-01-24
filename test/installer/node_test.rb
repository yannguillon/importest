# frozen_string_literal: true

require 'app_helper'

class NodeTest < ActiveSupport::TestCase
  include RailsAppHelpers
  include ActiveSupport::Testing::Isolation

  test 'install without importmap' do
    with_new_rails_app do
      exit_code, out, = run_command('bin/rails', 'importest:install:node')
      assert_equal 0, exit_code
      assert_match 'You must be running with importmap-rails (config/importmap.rb) to use this gem.', out
    end
  end

  test 'install with importmap' do
    with_new_rails_app do
      run_command('bin/rails', 'importmap:install')
      run_command('bin/rails', 'stimulus:install')
      run_command('bin/rails', 'importest:install:node')
      assert File.exist?('test/javascript/test_helper.js')
      assert File.exist?('test/javascript/node_importmap_loader.mjs')
      assert File.exist?('test/javascript/controllers/hello_controller.test.js')
      assert File.exist?('test/javascript/integrations/hello_controller.integration.test.js')
      assert File.exist?('test/javascript/package.json')
      assert File.exist?('bin/test_js')
      run_command('npm', '--prefix', 'test/javascript', 'install')
      exit_code, out, err = run_command('bin/test_js')
      assert_equal 0, exit_code, "#{out}\n#{err}"
    end
  end

  test 'install : importmap imports are avaialble in JS tests' do
    fixture_path = File.expand_path('../fixtures/node/importmap_load.test.js', __dir__)
    with_new_rails_app do
      run_command('bin/rails', 'importmap:install')
      run_command('bin/rails', 'stimulus:install')
      run_command('bin/rails', 'importest:install:node')
      exit_code, out, err = run_command('bin/importmap', 'pin', 'levenshtein')
      assert_equal 0, exit_code, "pin failed: #{out}\n#{err}"
      assert_match(/levenshtein/, File.read('config/importmap.rb'), 'levenshtein not in importmap.rb')
      run_command('cp', fixture_path, 'test/javascript')
      run_command('npm', '--prefix', 'test/javascript', 'install')
      exit_code, out, err = run_command('bin/test_js')
      assert_equal 0, exit_code, "#{out}\n#{err}"
    end
  end
end

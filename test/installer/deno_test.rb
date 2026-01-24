# frozen_string_literal: true

require 'app_helper'

class DenoTest < ActiveSupport::TestCase
  include RailsAppHelpers
  include ActiveSupport::Testing::Isolation

  test 'install without importmap' do
    with_new_rails_app do
      exit_code, out, = run_command('bin/rails', 'importest:install:deno')

      assert_equal 0, exit_code
      assert_match 'You must be running with importmap-rails (config/importmap.rb) to use this gem.', out
    end
  end

  test 'install with importmap' do
    with_new_rails_app do
      run_command('bin/rails', 'importmap:install')
      run_command('bin/rails', 'stimulus:install')
      run_command('bin/rails', 'importest:install:deno')
      assert File.exist?('test/javascript/test_helper.js')
      assert File.exist?('test/javascript/controllers/hello_controller.test.js')
      assert File.exist?('test/javascript/integrations/hello_controller.integration.test.js')
      assert File.exist?('test/javascript/deno.json')
      assert File.exist?('bin/test_js')
      exit_code, out, err = run_command('bin/test_js')
      assert_equal 0, exit_code, "#{out}\n#{err}"
    end
  end

  test 'install : importmap imports are avaialble in JS tests' do
    fixture_path = File.expand_path('../fixtures/deno/importmap_load.test.js', __dir__)
    with_new_rails_app do
      run_command('bin/rails', 'importmap:install')
      run_command('bin/rails', 'stimulus:install')
      run_command('bin/rails', 'importest:install:deno')
      exit_code, out, err = run_command('bin/importmap', 'pin', 'levenshtein')
      assert_equal 0, exit_code, "pin failed: #{out}\n#{err}"
      assert_match(/levenshtein/, File.read('config/importmap.rb'), 'levenshtein not in importmap.rb')
      run_command('cp', fixture_path, 'test/javascript')
      exit_code, out, err = run_command('bin/test_js')
      assert_equal 0, exit_code, "#{out}\n#{err}"
    end
  end
end

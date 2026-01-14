# frozen_string_literal: true

say 'Create test directory'
empty_directory 'test/javascript/controllers'
empty_directory 'test/javascript/integrations'
say 'Create task test directory'
empty_directory 'lib/tasks/test'

%w[
  test/javascript/test_helper.js
  test/javascript/controllers/hello_controller.test.js
  test/javascript/integrations/hello_controller.integration.test.js
  deno.json
  config/initializers/importest.rb
].each do |file|
  copy_file "#{__dir__}/#{file}", file
end

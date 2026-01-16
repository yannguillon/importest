# frozen_string_literal: true

say 'Create test directory'
empty_directory 'test/javascript/controllers'
empty_directory 'test/javascript/integrations'

%w[
  test/javascript/node_importmap_loader.mjs
  test/javascript/test_helper.js
  test/javascript/controllers/hello_controller.test.js
  test/javascript/integrations/hello_controller.integration.test.js
  config/initializers/importest.rb
  package.json
].each do |file|
  copy_file "#{__dir__}/#{file}", file
end

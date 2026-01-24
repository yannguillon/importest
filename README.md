# Importest for Rails
* Bridges your **Importmap Pins** to be available in a JS Runtime (Deno or Node)
* Adds the `rails test:js` command, to load this Runtime and run tests with **Importmap Pins** loaded
* Allows Stimulus unit and integration tests without a jsbundling configuration

## Installation
### Testing with Deno (2.1 > 2.5)
Recommended, as Deno has native support for importmap
1. Add the `importest` gem to your Gemfile: 
    ```ruby
   # Gemfile
   group :test do 
      gem 'importest'
   end
   ```
2. Run `bundle install`
3. Run `rails importest:install` or `rails importest:install:deno`
4. Run `rails test:js`

### Testing with Node (20 > 25)
Support for Node is done through a custom importmap loader, and is not recommended 
1. Add the `importest` gem to your Gemfile: `gem 'importest'`
2. Run `bundle install`
3. Run `rails importest:install:node`
4. Run `rails test:js`

## Test directory structure
```text
myrailsapp/
  test/
    javascript/
      */**.test.js
```

## Test directory structure for Stimulus
```text
myrailsapp/
  test/
    javascript/
      controllers/ # unit tests for controllers
        *.test.js
      integrations/ # when using a DOM
        *.integration.test.js
```

## Examples for testing Stimulus controllers
* Tests for the HelloController are available upon install
* `test/javascript/test_helper.js` contains basic DOM setup helpers

## License

Importest for Rails is released under the [MIT License](https://opensource.org/licenses/MIT).

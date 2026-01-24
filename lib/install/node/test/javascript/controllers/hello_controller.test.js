import { describe, it } from 'node:test'
import assert from 'node:assert/strict'
import HelloController from '../../../app/javascript/controllers/hello_controller.js'

describe('HelloController', () => {
  describe('connect()', () => {
    it('sets element textContent to "Hello World!"', () => {
      const controller = new HelloController()
      const mockElement = { textContent: '' }

      Object.defineProperty(controller, 'element', {
        get: () => mockElement,
        configurable: true
      })
      controller.connect()

      assert.equal(mockElement.textContent, 'Hello World!')
    })
  })
})

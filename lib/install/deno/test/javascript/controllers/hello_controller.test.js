import { assertEquals } from 'jsr:@std/assert'
import { it, describe } from 'jsr:@std/testing/bdd'
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

      assertEquals(mockElement.textContent, 'Hello World!')
    })
  })
})

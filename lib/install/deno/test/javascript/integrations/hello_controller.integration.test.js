import { assertEquals } from 'jsr:@std/assert'
import { it } from 'jsr:@std/testing/bdd'
import { describeControllerIntegration, getControllerInnerHTML, setControllerInnerHTML } from '../test_helper.js'
import HelloController from '../../../app/javascript/controllers/hello_controller.js'

describeControllerIntegration(HelloController, () => {
  it('sets element content to Hello World! when connected', async () => {
    assertEquals(getControllerInnerHTML(), 'Hello World!')
    await setControllerInnerHTML('')
    assertEquals(getControllerInnerHTML(), '')
  })
})

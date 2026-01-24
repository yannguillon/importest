import { it } from 'node:test'
import assert from 'node:assert/strict'
import { describeControllerIntegration, getControllerInnerHTML, setControllerInnerHTML } from '../test_helper.js'
import HelloController from '../../../app/javascript/controllers/hello_controller.js'

describeControllerIntegration(HelloController, () => {
  it('sets element content to Hello World! when connected', async () => {
    assert.equal(getControllerInnerHTML(), 'Hello World!')
    await setControllerInnerHTML('')
    assert.equal(getControllerInnerHTML(), '')
  })
})

import { Application } from '@hotwired/stimulus'
import { parseHTML } from 'npm:linkedom'
import { afterEach, beforeEach, describe as bddDescribe } from 'jsr:@std/testing/bdd'

let globalDocument
let globalWindow
let application
let currentControllerName

export function describeControllerIntegration (controller, fn) {
  const name = controller.name

  bddDescribe(name, () => {
    beforeEach(() => {
      const controllerName = name
        .replace(/Controller$/, '') // Remove "Controller" suffix
        .replace(/([a-z])([A-Z])/g, '$1-$2') // Convert camelCase to kebab-case
        .toLowerCase()

      const dom = parseHTML(`
    <!DOCTYPE html>
    <html>
      <body>
        <div data-controller="${controllerName}"></div>
      </body>
    </html>
  `)

      globalDocument = dom.document
      globalWindow = dom.window
      // Set globals needed by Stimulus
      globalThis.document = globalDocument
      globalThis.window = globalWindow
      globalThis.navigator = globalWindow.navigator
      globalThis.Element = globalWindow.Element
      globalThis.HTMLElement = globalWindow.HTMLElement
      globalThis.Node = globalWindow.Node
      globalThis.Document = globalWindow.Document
      globalThis.MutationObserver = globalWindow.MutationObserver
      application = Application.start(globalDocument.documentElement)
      application.register(name, controller)
      currentControllerName = name
    })

    afterEach(async () => {
      await cleanupDOM()
    })

    fn()
  })
}

export async function setControllerInnerHTML (content = '') {
  if (currentControllerName) {
    const controllerDiv = globalDocument.querySelector(`[data-controller="${currentControllerName}"]`)
    if (controllerDiv) {
      controllerDiv.innerHTML = content.trim()
    } else {
      globalDocument.body.innerHTML = `<div data-controller="${currentControllerName}">${content.trim()}</div>`
    }
  } else {
    globalDocument.body.innerHTML = content.trim()
  }

  return getControllerInnerHTML()
}

export function getControllerInnerHTML () {
  if (currentControllerName) {
    const controllerDiv = globalDocument.querySelector(`[data-controller="${currentControllerName}"]`)
    if (controllerDiv) {
      return controllerDiv.innerHTML.trim()
    }
  }

  return globalDocument.body.innerHTML.trim()
}

async function cleanupDOM () {
  if (globalDocument) {
    globalDocument.body.innerHTML = ''
  }
  currentControllerName = null
}

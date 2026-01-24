import { Application } from '@hotwired/stimulus'
import { parseHTML } from 'linkedom'
import { describe as bddDescribe, beforeEach, afterEach } from 'node:test'

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
      // Use Object.defineProperty for properties that might be read-only in Node 24+
      Object.defineProperty(globalThis, 'document', { value: globalDocument, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'window', { value: globalWindow, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'navigator', { value: globalWindow.navigator, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'Element', { value: globalWindow.Element, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'HTMLElement', { value: globalWindow.HTMLElement, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'Node', { value: globalWindow.Node, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'Document', { value: globalWindow.Document, writable: true, configurable: true })
      Object.defineProperty(globalThis, 'MutationObserver', { value: globalWindow.MutationObserver, writable: true, configurable: true })
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

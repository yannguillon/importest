import { register as nodeRegister } from 'node:module'
import { readFileSync } from 'node:fs'
import { pathToFileURL } from 'node:url'

const importmap = JSON.parse(readFileSync(process.env.IMPORTMAP_PATH, 'utf8'))

export async function resolve (specifier, context, nextResolve) {
  const mapped = importmap.imports?.[specifier]
  return mapped ? { url: mapped, shortCircuit: true, format: 'module' } : nextResolve(specifier, context)
}

export async function load (url, context, nextLoad) {
  if (url.startsWith('http://') || url.startsWith('https://')) {
    return { format: 'module', source: await (await fetch(url)).text(), shortCircuit: true }
  }
  return nextLoad(url, context)
}

export function register () {
  nodeRegister(pathToFileURL(import.meta.filename), import.meta.url)
}

register()

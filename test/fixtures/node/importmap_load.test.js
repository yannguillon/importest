import Levenshtein from 'levenshtein'
import { it } from 'node:test'
import assert from 'node:assert/strict'

it('loads arbitrary packages from importmap"', () => {
  assert.equal(Levenshtein('Hello World!', 'Rails says Hello!'), 13)
})

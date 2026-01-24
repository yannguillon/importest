import Levenshtein from 'levenshtein'
import { assertEquals } from 'jsr:@std/assert'
import { it } from 'jsr:@std/testing/bdd'

it('loads arbitrary packages from importmap"', () => {
  assertEquals(Levenshtein('Hello World!', 'Rails says Hello!'), 13)
})

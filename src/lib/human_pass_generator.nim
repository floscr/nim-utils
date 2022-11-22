import std/[
  strformat,
  strutils,
  sequtils,
  sugar,
  random,
]
import fp/[
  either,
  tryM,
  option,
  list,
]

const DEFAULT_WORD_COUNT* = 4
const DEFAULT_WORD_LENGTH* = 8
const DEFAULT_NUMBER_LENGTH* = 4

proc genRandomNumberPart(maxNumberLength = DEFAULT_NUMBER_LENGTH): auto =
  randomize()
  let randomNumber = toSeq(1..maxNumberLength)
  .map(x => rand(9))
  .join("")
  randomNumber

proc generatePass*(
  maxWordCount = DEFAULT_WORD_COUNT,
  maxWordLength = DEFAULT_WORD_LENGTH,
  maxNumberLength = DEFAULT_NUMBER_LENGTH,
  seed = 10_000_000,
  isRandomized = true,
  hasNumbers = true,
  # hasSymbols = false,
  # hasMixedCasing = false,
): string =
  if isRandomized: randomize()

  let seed = rand(seed)
  var r = initRand(seed)

  let numbers =
    if hasNumbers: @[genRandomNumberPart(maxNumberLength)]
    else: newSeq[string]()

  var dictionaryDump = sh("aspell -d en dump master")
  .fromEither()
  .map(x => x.split("\n"))
  .getOrElse(newSeq[string]())
  r.shuffle(dictionaryDump)

  # Accumulate words that are shorter than maxWordLength
  var wordParts = newSeq[string]()
  var index = 0
  while wordParts.len < maxWordCount:
    let newWord = dictionaryDump[index]
    if newWord.len <= maxWordLength:
       wordParts.add(newWord)
    index = index + 1

  let words = wordParts
  .map(x => x
       .replace("'s")
       .toLower())

  concat(
    words,
    numbers,
  )
  .join("-")

when isMainModule:
  assert generatePass(seed=30, hasNumbers=false, isRandomized=false) == "primed-grus-touch-raillery"

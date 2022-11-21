import os
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

proc main(wordCount = 4, maxWordLength = 8): string =
  randomize()

  let seed = rand(10_000_000)
  var r = initRand(seed)

  randomize()
  let randomNumber = toSeq(1..4)
  .map(x => rand(9))
  .join("")


  var words = sh("aspell -d en dump master")
  .fromEither()
  .map(x => x.split("\n"))
  .getOrElse(newSeq[string]())

  r.shuffle(words)

  var wordsWithLimit = newSeq[string]()
  var index = 0
  while wordsWithLimit.len < wordCount:
    let newWord = words[index]

    if newWord.len <= maxWordLength:
       wordsWithLimit.add(newWord)

    index = index + 1

  let wordSequence = wordsWithLimit
  .map(x => x
       .replace("'s")
       .toLower())
  .join("-")

  wordSequence & "-" & randomNumber

echo main()

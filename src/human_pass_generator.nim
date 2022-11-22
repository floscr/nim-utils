import std/[
  os,
  sugar,
  strformat,
  strutils,
]
import argparse
import fp/[
  either,
  tryM,
]
import ./lib/human_pass_generator

const VERSION = "1.0"

proc cli(args = commandLineParams()): auto =
  var p = newParser():
    flag("-v", "--version")
    help("human_pass_generator")
    option("-mwc", "--max-word-count", help="Number of words", default=some($DEFAULT_WORD_COUNT))
    option("-mwl", "--max-word-length", help="Number of words", default=some($DEFAULT_WORD_LENGTH))
    option("-mnl", "--max-number-length", help="Number of digits in number", default=some($DEFAULT_NUMBER_LENGTH))
    option("-s", "--seed", help="Seed", default=some("10_000_000"))
    flag("-nn", "--no-number", help="Disable numbers")
    flag("-nr", "--no-random", help="Disable randomization (rely on seed, only works for words)")
    argparse.run():
      let (msg, exitCode) =
        if opts.version:
          (VERSION, 0)
        else:
          (generatePass(
            maxWordCount=opts.maxWordCount.parseInt,
            maxWordLength=opts.maxWordLength.parseInt,
            maxNumberLength=opts.maxNumberLength.parseInt,
            seed=opts.seed.parseInt,
            isRandomized=not opts.noRandom,
            hasNumbers=not opts.noNumber,
          ), 0)

      echo msg
      quit(exitCode)

  p.run(args)

when isMainModule:
  cli(@["-mwc=3", "-mwl=10", "-mnl=10"])

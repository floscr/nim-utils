import std/[
  os,
  sugar,
]
import argparse
import fp/[
  either,
  maybe,
  trym,
]
import ./lib

const VERSION = "1.2"

proc cli(args = commandLineParams()): auto =
  var p = newParser():
    flag("-v", "--version")
    help("get_url_title")
    arg("url", nargs = -1)
    argparse.run():
      let (msg, exitCode) =
        if opts.version:
          (VERSION, 0)
        else:
          urlToTitle(opts.url[0])
          .fold(
            err => (err, 1),
            suc => (suc, 0)
          )

      echo msg
      quit(exitCode)

  if args.len == 0:
    echo p.help
    quit(0)

  p.run(args)

when isMainModule:
  cli()

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
import ./lib/get_url_title

const VERSION = "1.0"

proc cli(args = commandLineParams()): auto =
  var p = newParser():
    flag("-v", "--version")
    help("get_url_title")
    arg("url")
    argparse.run():
      if opts.version:
        echo VERSION
      else:
        let (msg, exitCode) = urlToTitle(opts.url)
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

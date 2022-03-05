import std/htmlparser
import std/xmltree
import std/httpclient
import std/sugar
import std/os
import argparse
import fp/trym
import fp/list
import fp/either
import fp/maybe

proc getHtmlTitle(html: string): EitherS[string] =
  html
  .parseHtml()
  .findAll("title")
  .asList()
  .headMaybe()
  .asEither("Could not find title in html")
  .map((x: XmlNode) => x.innerText())

proc urlToTitle(url: string): EitherS[string] =
  (tryM do: newHttpClient().getContent(url))
  .asEitherS()
  .flatMap((x: string) => x.getHtmlTitle())

proc cli(args = commandLineParams()): auto =
  var p = newParser():
    help("get_url_title")
    arg("url")
    argparse.run():
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

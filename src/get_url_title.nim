import std/[
  htmlparser,
  httpclient,
  os,
  sugar,
  xmltree,
]
import argparse
import fp/[
  either,
  list,
  maybe,
  trym,
]

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

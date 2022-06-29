import std/[
  htmlparser,
  httpclient,
  os,
  strformat,
  strutils,
  sugar,
  uri,
  xmltree,
]
import fp/[
  either,
  list,
  maybe,
  trym,
]
import fusion/matching
import ../utils/str

{.experimental: "caseStmtMacros".}

func alternativeUrl(url: string): string =
  ## Get alternative for urls that don't return parseable html.
  let u = url.parseUri()
  case u.hostName:
    of "twitter.com": $("https://nitter.net".parseUri() / u.path) & (if u.query != "": "?" & u.query else: "")
    else: url

proc getHtmlTitle(html: string): EitherS[string] =
  html
  .parseHtml()
  .findAll("title")
  .asList()
  .headMaybe()
  .asEither("Could not find title in html")
  .map((x: XmlNode) => x.innerText())

func modifyTitle(title: string, url: string): string =
  let u = url.parseUri()

  case u.hostName:
    of "nitter.net":
      var title: string = title.split("\n")[0]
      title.removeSuffix("|nitter")
      &"Tweet: {title.trimAt(100)}"
    else: title

proc urlToTitle*(url: string): EitherS[string] =
  let u = url.alternativeUrl()

  (tryM do: newHttpClient() .getContent(u))
  .asEitherS()
  .flatMap((x: string) => x.getHtmlTitle())
  .map((x: string) => x.modifyTitle(u))

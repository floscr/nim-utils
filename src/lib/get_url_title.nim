import std/[
  htmlparser,
  httpclient,
  strformat,
  strutils,
  sugar,
  uri,
  xmltree,
]
import fp/[
  either,
  list,
  tryM,
]
import ../utils/str

{.experimental: "caseStmtMacros".}

func alternativeUrl(url: string): string =
  ## Get alternative for urls that don't return parseable html.
  let u = url.parseUri()
  case u.hostName:
    of "twitter.com": $("https://nitter.net".parseUri() / u.path) & (if u.query != "": "?" & u.query else: "")
    else: url

proc getHtmlTitle(html: string): EitherS[string] =
  (tryM do: html.parseHtml())
  .asEitherS()
  # Verify that the body is actually html and not only text
  .flatMap((x: XmlNode) => (if x.kind == xnText: (&"No html found in string:\n{x}").left(XmlNode)
                            else: x.rightS()))
  .flatMap((x: XmlNode) => x
    .findAll("title")
    .asList()
    .headMaybe()
    .asEither("Could not find title in html")
    .map((x: XmlNode) => x.innerText())
  )

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

  (tryM do: newHttpClient().getContent(u))
  .mapErrorMessage((x: string) => &"HTTP Status Code Error: {x}")
  .asEitherS()
  .flatMap((x: string) => x.getHtmlTitle())
  .map((x: string) => x.modifyTitle(u))

when isMainModule:
  assert urlToTitle("http://httpstat.us/200") == "No html found in string:\n200 OK".left(string)
  assert urlToTitle("http://httpstat.us/404") == "HTTP Status Code Error: 404 Not Found".left(string)

import std/[
  sugar,
  strformat,
]
import fp/[
  option
]

const DEFAULT_TRIM_TRUNCATE_CHAR = "…"

func trimAt(str: string, index: int, truncateStr = DEFAULT_TRIM_TRUNCATE_CHAR.some()): string =
  if index < 0 or
     str.len == 0 or
     (str.len - 1 < index): str
  else: str[0..index] & truncateStr.getOrElse("")

when isMainModule:
  block testTrimAt:
    let testStr = "AbcD"
    # Out of bounds tests
    assert testStr.trimAt(-1) == testStr
    assert testStr.trimAt(10) == testStr
    # Regular behavior tests
    assert "AbcD".trimAt(2) == "Abc" & DEFAULT_TRIM_TRUNCATE_CHAR

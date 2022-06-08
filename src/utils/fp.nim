import std/[
  osproc,
  strutils,
  sugar,
]
import fp/[
  either,
  option,
]

proc findCond*[T](xs: seq[T], cond: T -> bool): Option[T] =
  for x in xs:
    if cond(x):
      return some(x)
  return none(T)

import os
import std/[
  strformat,
  strutils,
  sugar,
]
import fp/[
  either,
  tryM,
]

func intToBatteryIcon(level: int): string =
  case level:
    of 0..10:
      ""
    of 11..20:
      ""
    of 21..30:
      ""
    of 31..50:
      ""
    of 51..70:
      ""
    of 71..high(int):
      ""
    else:
      ""

proc main(): auto =
  tryEt(paramStr(1))
    .mapErrorMessage(err => "Missing first argument bluetooth device id.")
    .flatMap((deviceId: string) => sh(&"based-connect {deviceId} -b").fromEither())
    .flatMap((x: string) => tryEt(x.parseInt()))
    .map(intToBatteryIcon)
    .bitap(
      (x: ref Exception) => (
        echo &"Error:\n {x.msg}"; quit(1)
      ),
      (x: string) => (
        echo x; quit(0)
      )
    )

discard main()

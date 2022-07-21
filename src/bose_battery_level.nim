import os
import std/[
  strformat,
  strutils,
  sugar,
]
import fp/[
  either,
  tryM,
  option,
]
import ./utils/fp

proc intToBatteryIcon(level: int): string =
  case level:
    of 0..10:         ""
    of 11..20:        ""
    of 21..30:        ""
    of 31..50:        ""
    of 51..70:        ""
    of 71..high(int): ""
    else:             ""

proc deviceIsOnline(deviceId: string): bool =
  sh(&"bt-device -i {deviceId}")
  .fold(
    (_) => false,
    (x: string) => x
      .split("\n")
      .findCond((x: string) => x.contains("Connected: 1"))
      .isSome()
  )

proc main(): auto =
  tryEt(paramStr(1))
    .mapErrorMessage(err => "Missing first argument bluetooth device id.")

    .filter(
      (x: string) => deviceIsOnline(x),
      (x: string) => &"Device \"{x}\" is not online",
    )

    .flatMap((deviceId: string) => sh(&"based-connect {deviceId} -b").fromEither())
    .flatMap((x: string) => tryEt(x.parseInt()))
    .map((x: int) => &"<fn=2></fn> {x}% <fn=2> {x.intToBatteryIcon()}</fn>")

    .bitap(
      (x: ref Exception) => (
        echo ""
      ),
      (x: string) => (
        echo x; quit(0)
      )
    )

discard main()

# Package

version       = "0.1.0"
author        = "Florian Schroedl"
description   = ""
license       = "MIT"
srcDir        = "src"
bin           = @["cli"]

# Dependencies

requires "nim >= 1.6.2"
requires "https://github.com/floscr/nimfp#a158a4524a813c315ede19ca22d5983f92c00608"
requires "fusion"
requires "argparse"

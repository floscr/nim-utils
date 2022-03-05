import std/osproc
import std/strutils
import fp/either

proc sh*(cmd: string, opts = {poStdErrToStdOut}): Either[string, string] =
  ## Execute a shell command and wrap it in an Either
  ## Right for a successful command (exit code: 0)
  ## Left for a failing command (any other exit code, so 1)
  let (res, exitCode) = execCmdEx(cmd, opts)
  if exitCode == 0:
    return res
        .strip
        .right(string)
  return res
    .strip
    .left(string)

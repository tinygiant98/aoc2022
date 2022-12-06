import system/io, strutils, strformat, sets

proc isMarker(s: string): bool =
  s.toHashSet.len == s.len

proc findMarker(signal, `type`: string, size: int) =
  for i in 0..signal.len-size:
    if signal[i..i + size - 1].isMarker:
      echo fmt"{`type`} marker at {i + size}"
      return

var
  signal = readAll(open("data/day06.txt", fmRead))

when isMainModule:
  findMarker(signal, "Signal", 4)
  findMarker(signal, "Message", 14)

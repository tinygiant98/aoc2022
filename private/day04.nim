import system/io, strutils, strformat

proc ranges(sections: seq[string]): seq[seq[int]] =
  var ranges: seq[seq[int]]
  
  for section in sections:
    var
      firstSection = parseInt(section[0..section.find("-")-1])
      lastSection = parseInt(section[section.find("-")+1..^1])
      areas = @[firstSection, lastSection]

    ranges.add(areas)
  
  return ranges

proc isContained(sections: seq[string]): int =
  var ranges = sections.ranges()

  if ranges[0][0] <= ranges[1][0] and ranges[0][1] >= ranges[1][1]:
    return 1
  elif ranges[1][0] <= ranges[0][0] and ranges[1][1] >= ranges[0][1]:
    return 1
  else: return 0 

proc isOverlapped(sections: seq[string]): int =
  var ranges = sections.ranges()

  if ranges[0][1] < ranges[1][0]: return 0
  elif ranges[1][1] < ranges[0][0]: return 0
  else: return 1

var
  sections: seq[string]
  group: seq[string]
  file = open("data/day04.txt", fmRead)
  contained, overlapped: int

when isMainModule:
  while not endOfFile(file):
    var line = readLine(file)
    sections.add(line.split(","))

  for n in 0..sections.len-1:
    group.add(sections[n])
    if (n + 1) mod 2 == 0:
      contained += group.isContained()
      overlapped += group.isOverlapped()
      group = @[]

  echo fmt"Contained sections - {contained}"
  echo fmt"Overlapped sections - {overlapped}"

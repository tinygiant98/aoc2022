import system/io, strutils, strformat, regex, sequtils

let moveRe = re"move\s*(\d+)\s*from\s*(\d+)\s*to\s*(\d+)"
var moves: seq[string]

proc runCrateMover9000(crates: seq[seq[char]]) =
  var crates = crates
  
  for move in moves:
    for m in findAll(move, moveRe):
      let 
        count = m.group(0, move)[0].parseInt - 1
        source = m.group(1, move)[0].parseInt - 1
        destination = m.group(2, move)[0].parseInt - 1

      for i in 0..count:
        crates[destination].add(crates[source][^1])
        crates[source] = crates[source][0..^2]

  var desired: seq[char]
  for crate in crates:
    desired.add(crate[^1])

  echo fmt"Desired Crates (9000): {desired.join()}"

proc runCrateMover9001(crates: seq[seq[char]]) =
  var crates = crates
  
  for move in moves:
    for m in findAll(move, moveRe):
      let 
        count = m.group(0, move)[0].parseInt
        source = m.group(1, move)[0].parseInt - 1
        destination = m.group(2, move)[0].parseInt - 1

      crates[destination] = concat(crates[destination], crates[source][^count..crates[source].high])
      crates[source] = crates[source][0..^count + 1]

  var desired: seq[char]
  for crate in crates:
    desired.add(crate[^1])

  echo fmt"Desired Crates (9001): {desired.join()}"

proc createInput(): seq[seq[char]] =
  result.add("DBJV".items.toSeq)
  result.add("PVBWRDF".items.toSeq)
  result.add("RGFLDCWQ".items.toSeq)
  result.add("WJPMLNDB".items.toSeq)
  result.add("HNBPCSQ".items.toSeq)
  result.add("RDBSNG".items.toSeq)
  result.add("ZBPMQFSH".items.toSeq)
  result.add("WLF".items.toSeq)
  result.add("SVFMR".items.toSeq)

var
  file = open("data/day05.txt", fmRead)
  crates: seq[seq[char]]

when isMainModule:
  crates = createInput()

  while not endOfFile(file):
    var line = readLine(file)
    moves.add(line.split(","))

  runCrateMover9000(crates)
  runCrateMover9001(crates)

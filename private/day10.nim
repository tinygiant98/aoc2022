import system/io, strutils, strformat

type
  Cycle = tuple
    cycle, x, power: int

var
  file = open("data/day10.txt", fmRead)
  instructions: seq[seq[string]]
  cycles: seq[Cycle]
  sprites: seq[char]

proc sum(cycles: seq[Cycle]): int =
  var x = 20
  while x <= cycles.len:
    result += cycles[x-1].power
    x += 40

proc add(cycle: Cycle, step: int = 0) =
  cycles.add(cycle)
  cycles[^1].cycle.inc 
  cycles[^1].x += step
  cycles[^1].power = cycles[^1].cycle * cycles[^1].x

proc populateCycleData() =
  cycles.add((1, 1, 0))

  for instruction in instructions:
    cycles[^1].add()

    if instruction[0] == "addx":
      cycles[^1].add(instruction[1].parseInt)

proc findInterestingSignals() =
  echo fmt"Interesting signal sum: {cycles.sum}"

proc displayMessage() =
  for i in 0..cycles.len-1:
    let target = i mod 40

    if target + 1 in cycles[i].x..cycles[i].x+2: sprites.add('#')
    else: sprites.add('.')

  var x = 39
  while x < cycles.len:
    echo sprites[x-39..x].join
    x += 40

when isMainModule:
  while not endOfFile(file):
    instructions.add(readLine(file).split)

  populateCycleData()
  findInterestingSignals()
  displayMessage()

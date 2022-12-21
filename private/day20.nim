import system/io, strformat, strutils, sequtils

type
  Node = tuple[value, id: int]
  Ring = seq[Node]

let
  input = "data/day20.txt".readFile

proc at(ring: Ring): int64 =
  let zeroIndex = ring.find(ring.filterIt(it.value == 0)[0])
  
  result = ring[(zeroIndex + 1000) mod ring.len].value +
           ring[(zeroIndex + 2000) mod ring.len].value +
           ring[(zeroIndex + 3000) mod ring.len].value

proc decode(prototype: Ring, rounds: int64): int64 = 
  var
    currentIndex, newIndex: int64
    ring = prototype
  
  for round in 1..rounds:
    for node in prototype:
      var hold: Ring

      if node.value == 0: continue

      currentIndex = ring.find(node)
      newIndex = (currentIndex + node.value) mod ring.high

      if newIndex <= ring.low:
        newIndex.inc(ring.high)

      if currentIndex == newIndex: continue
      elif currentIndex < newIndex:
        hold.add(ring[ring.low ..< currentIndex])
        hold.add(ring[currentIndex + 1 .. newIndex])
        hold.add(ring[currentIndex])
        hold.add(ring[newIndex + 1 .. ring.high])
      else:
        hold.add(ring[ring.low ..< newIndex])
        hold.add(ring[currentIndex])
        hold.add(ring[newIndex ..< currentIndex])
        hold.add(ring[currentIndex + 1 .. ring.high])

      ring = hold

  return ring.at

var
  ring: Ring
  counter: int

for line in input.splitLines:
  ring.add (line.parseInt, counter)
  counter.inc

when isMainModule:
  var clone: Ring

  clone = ring
  echo fmt"Step 1 Decode (1 Round): {clone.decode(1)}"

  clone = ring.map(proc(x: Node): Node = (x.value * 811589153, x.id))
  echo fmt"Step 2 Decode (10 Rounds + key): {clone.decode(10)}"
  
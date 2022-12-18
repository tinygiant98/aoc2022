import system/io, strutils, strformat, sequtils, strscans, sets, math

type
  Point = tuple[x, y: int]
  Pairing = tuple[s, b: Point, md: int]

var
  pairings: seq[Pairing]

proc md(s, b: Point): int = abs(s.x - b.x) + abs(s.y - b.y)

proc inBounds(p, bounds: Point): bool =
  p.x in bounds[0]..bounds[1] and p.y in bounds[0]..bounds[1]

proc readSensorData() =
  var sx, sy, bx, by: int

  for line in readFile("data/day15.txt").splitLines:
    if line.scanf("Sensor at x=$i, y=$i: closest beacon is at x=$i, y=$i", sx, sy, bx, by):
      pairings.add(((sx, sy), (bx, by), md((sx, sy), (bx, by))))

proc getExclusions(row: int = 2_000_000): HashSet[int] =
  var
    dist: int
    exclusions: HashSet[int]

  for (s, b, md) in pairings:
    dist = abs(row - s.y)

    if dist > md: continue
    else:
      let width = abs(dist - md)
      for i in s.x-width..s.x+width:
        exclusions.incl(i)

  return exclusions

proc getTunerFrequency(bounds: Point = (0, 4_000_000)): int =
  var a, b: HashSet[int]

  for (s, _, md) in pairings:
    a.incl(s.y-s.x+md+1)
    a.incl(s.y-s.x-md-1)
    b.incl(s.x+s.y+md+1)
    b.incl(s.x+s.y-md-1)

  for j in a:
    for k in b:
      let point: Point = (floorDiv((k - j), 2), floorDiv((j + k), 2))
      if point.inBounds(bounds):
        if pairings.all(proc (x: Pairing): bool = md(x.s, point) > x.md):
          return point.x * 4_000_000 + point.y

when isMainModule:
  readSensorData()
  echo fmt"Part 1: total exclusions = {getExclusions().len-1}"
  echo fmt"Part 2: tuning frequency = {getTunerFrequency()}"

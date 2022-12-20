import system/io, strformat, strutils, sequtils, sets, regex

type
    Cube = tuple[x, y, z: int]
    Ball = seq[Cube]
    Bounds = tuple[min, max: Cube]

let
  cubes = "data/day18.txt".readFile
  offsets = @[(1, 0, 0), (0, 1, 0), (0, 0, 1), (-1, 0, 0), (0, -1, 0), (0, 0, -1)]
    
var
  ball: Ball
  bounds: Bounds

proc `+`(l, r: Cube): Cube =
  (l.x + r.x, l.y + r.y, l.z + r.z)

proc parseInts(s: string): seq[int] =
  s.findAndCaptureAll(re"-?\d+").map(parseInt)

proc expand(b: var Bounds) =
  b.max.x += 1
  b.max.y += 1
  b.max.z += 1
  b.min.x -= 1
  b.min.y -= 1
  b.min.z -= 1

proc cube(s: seq[int]): Cube =
  (s[0], s[1], s[2])

proc neighborhood(cube: Cube): seq[Cube] =
  for offset in offsets:
    result.add(cube + offset)

proc countVisibleFaces(cube: Cube): int =
  6 - ball.countIt(it in cube.neighborhood)

proc countVisibleFaces(ball: Ball): int =
  ball.map(proc(cube: Cube): int = cube.countVisibleFaces).foldl(a + b)

proc `notin`(cube: Cube, bounds: Bounds): bool =
  cube.x < bounds.min.x or cube.x > bounds.max.x or
  cube.y < bounds.min.y or cube.y > bounds.max.y or
  cube.z < bounds.min.z or cube.z > bounds.max.z

for cube in cubes.splitLines:
  ball.add(cube.parseInts.cube)

bounds.min = (ball.mapIt(it.x).min, ball.mapIt(it.y).min, ball.mapIt(it.z).min)
bounds.max = (ball.mapIt(it.x).max, ball.mapIt(it.y).max, ball.mapIt(it.z).max)

proc countSurfaceFaces(ball: Ball): int =
  var
    queue, checked: seq[Cube]
  
  bounds.expand
  queue.add (bounds.min.x, bounds.min.y, bounds.min.z)

  while queue.len > 0:
    let cube = queue[0]
    queue.delete(0)

    if cube in checked: continue
    else: checked.add(cube)

    for deltaX in -1..1:
      for deltaY in -1..1:
        for deltaZ in -1..1:
          if deltaX.abs + deltaY.abs + deltaZ.abs != 1: continue

          let candidate = (cube.x + deltaX, cube.y + deltaY, cube.z + deltaZ)
          if candidate notin bounds:
            continue

          if candidate in ball: result.inc
          else: queue.add(candidate)        

when isMainModule:
  let visibleFaces = ball.countVisibleFaces
  
  echo fmt"Visible faces: {visibleFaces}"
  echo fmt"Steam: {ball.countSurfaceFaces}"
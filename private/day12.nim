import system/io, strutils, strformat, sequtils, algorithm

type 
  Point = (int, int)
  Direction = enum
    up, down

var
  map: seq[seq[char]]

proc width(map: seq[seq[char]]): int = map[0].len
proc height(map: seq[seq[char]]): int = map.len
proc area(map: seq[seq[char]]): int = map.width * map.height
proc index(p: Point): int = p[0] + p[1] * map.width

proc find(c: char): Point =
  for col in 0..map.width-1:
    for row in 0..map.width-1:
      if map[col][row] == c:
        return (row, col)

proc elevation(c: char): int =
  case c:
  of 'S': 'a'.ord
  of 'E': 'z'.ord
  else: c.ord

proc `in`(p: Point, map: seq[seq[char]]): bool =
  p[0] in 0..map.width-1 and p[1] in 0..map.height-1

proc `[]`(map: seq[seq[char]], p: Point): char = map[p[1]][p[0]]

proc neighbors(p: Point): seq[Point] =
  let
    neighbors = [(0,1),(0,-1),(1,0),(-1,0)]

  for neighbor in neighbors:
    let
      x = p[0] + neighbor[0]
      y = p[1] + neighbor[1]

    if (x, y) in map:
      result.add((x, y))

proc populateMapData(): seq[seq[char]] = 
  let lines = readFile("data/day12.txt").split("\r\n")

  for line in lines:
    result.add(line.items.toSeq)

proc pop(points: var seq[Point]): Point =
  result = points[0]
  points.delete(0)

proc dir(start, goal: char): Direction =
  if start.elevation < goal.elevation: Direction.up
  else: Direction.down

proc findPath(start: char = 'S', goal: char = 'E'): int =
    var
      direction = dir(start, goal)
      dist = newSeq[int](map.area)
      start = start.find
      queue = @[start]

    dist.fill(high(int))
    dist[start.index] = 0

    while queue.len > 0:
      var point = queue.pop
      if map[point[1]][point[0]] == goal:
        return dist[point.index]
      else:
        for neighbor in point.neighbors:
          if direction == up:
            if map[point].elevation >= map[neighbor].elevation-1:
              let newDist = dist[point.index]+1
              if newDist < dist[neighbor.index]:
                queue.add(neighbor)
                dist[neighbor.index] = newDist
          else:
            if map[point].elevation <= map[neighbor].elevation+1:
              let newDist = dist[point.index]+1
              if newDist < dist[neighbor.index]:
                queue.add(neighbor)
                dist[neighbor.index] = newDist

    return -1

when isMainModule:
  map = populateMapData()

  echo fmt"Shortest path from S to E = {findPath()}"
  echo fmt"Shortest path from E to 'a' = {findPath('E', 'a')}"

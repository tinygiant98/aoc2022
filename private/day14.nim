import system/io, strutils, strformat, sequtils, strscans

type
  Point = tuple[x, y: int]
  Wall = seq[Point]
  Walls = seq[Wall]

var
  offsetX, floor, grains: int
  maxGrid: (int, int) = (-1000, -1000)
  minGrid: (int, int) = (1000, 1000)
  grid: seq[seq[char]]
  source: Point = (500, 0)
  grain: Point
  walls: Walls
  halt: bool = false

proc step(p: Point): char = grid[p.y+1][p.x]
proc inc(p: var Point) = p.y.inc
proc canDropLeft(p: Point): bool = grid[p.y+1][p.x-1] == '.'
proc canDropRight(p: Point): bool = grid[p.y+1][p.x+1] == '.'
proc stepLeft(p: var Point) = p.x.dec
proc stepRight(p: var Point) = p.x.inc

proc lost(grain: Point): bool = 
  if grain.y > floor:
    halt = true

  return halt

iterator `..`(l, r: Point): Point =
  let
    start = min(l, r)
    finish = max(l, r)

  for x in start.x..finish.x:
    for y in start.y..finish.y:
      yield (x, y)

proc dropGrain(start: Point = (-1, -1)) =
  grain = if start == (-1, -1): source else: start

  while grain.step == '.':
    grain.inc
    if grain.lost:
      return

  if grain.canDropLeft:
    grain.stepLeft
    grain.dropGrain
  elif grain.canDropRight:
    grain.stepRight
    grain.dropGrain
  else:
    if grain == source:
      halt = true
      return

    grid[grain.y][grain.x] = 'o'
    return

proc buildWalls() =
  grid[source.y][source.x] = 'S'

  for wall in walls:
    for n in 0..wall.len-2:
      for (x, y) in wall[n]..wall[n+1]:
        grid[y][x] = '#'

proc resetGrid() = 
  for r in grid.low..grid.high:
    for c, col in grid[r]:
      if col == 'o': grid[r][c] = '.'

  halt = false
  grains = 0

proc defineGrid() =
  for i in 0..maxGrid[1]+1:
    grid.add(newSeqWith(1000, '.'))

  offsetX = minGrid[0] - 5
  floor = maxGrid[1]

  buildWalls()

proc populateGrid() =
  for line in readFile("data/day14.txt").splitLines:
    var wall: Wall
    let path = line.split("->")
    
    for brick in path:
      var x, y: int
      if brick.strip.scanf("$i,$i", x, y):
        minGrid = (min(minGrid[0], x), min(minGrid[1], y))
        maxGrid = (max(maxGrid[0], x), max(maxGrid[1], y))
        wall.add((x,y))

    walls.add(wall)
  defineGrid()

proc run() =
  while not halt:
    grains.inc
    dropGrain()

proc part1() =
  populateGrid()
  run()

  echo fmt"Part 1: Grains = {grains-1}"

proc part2() =
  resetGrid()
  grid.add(newSeqWith(1000, '#'))
  floor.inc
  run()

  echo fmt"Part 2: Grains = {grains}"

when isMainModule:
  part1()
  part2()

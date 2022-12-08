import system/io, strutils, strformat, sequtils, algorithm

proc getColumn(forest: seq[seq[int]], c: int): seq[int] =
  for r in 0..forest.len-1:
    result.add(forest[r][c])

proc lookNorth(forest: seq[seq[int]], r, c: Natural): seq[int] =
  var column = getColumn(forest, c)[0..r-1]
  column.reverse
  return column

proc lookSouth(forest: seq[seq[int]], r, c: Natural): seq[int] =
  getColumn(forest, c)[r+1..^1]

proc lookWest(forest: seq[seq[int]], r, c: Natural): seq[int] =
  var row = forest[r][0..c-1]
  row.reverse
  return row

proc lookEast(forest: seq[seq[int]], r, c: Natural): seq[int] =
  forest[r][c+1..^1]

proc evaluateScenicScores(forest: seq[seq[int]]) =
  var
    scores: seq[int]

  for r in 1..forest.len-2:
    for c in 1..forest[0].len-2:
      var
        target = forest[r][c]
        n = forest.lookNorth(r, c)
        e = forest.lookEast(r, c)
        w = forest.lookWest(r, c)
        s = forest.lookSouth(r, c)
        views = @[n, e, w, s]
        score: int = 1

      for view in views:
        if view.len == 1: continue
        else:
          for i in view.low..view.high:
            if view[i] >= target:
              score *= i+1
              break
            elif i+1 == view.high:
              score *= i+2
              break
            elif view[i+1] >= view[i]: continue

      scores.add(score)
      score = 1
  
  echo fmt"The greatest scenic score is {scores[scores.maxIndex]}"

proc countVisibleTrees(forest: seq[seq[int]]) =
  var 
    visibleTrees: int
    perimeter = forest.len * 2 + forest[0].len * 2 - 4

  for r in 1..forest.len-2: 
    for c in 1..forest[0].len-2:
      var  
        target = forest[r][c]        
        w = forest.lookWest(r, c).filterIt(it >= target)
        e = forest.lookEast(r, c).filterIt(it >= target)
        n = forest.lookNorth(r, c).filterIt(it >= target)
        s = forest.lookSouth(r, c).filterIt(it >= target)

      if n.len == 0 or s.len == 0 or e.len  == 0 or w.len  == 0:
        visibleTrees.inc

  echo fmt"{visibleTrees + perimeter} trees are visible" 

var
  forest: seq[seq[int]]
  file = open("data/day08.txt", fmRead)

when isMainModule:
  while not endOfFile(file):
    var
      line = readLine(file)
      lineSeq = @line.mapIt($it)
    
    forest.add(lineSeq.mapIt(it.parseInt));

  countVisibleTrees(forest)
  evaluateScenicScores(forest)
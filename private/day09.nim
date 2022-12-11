import system/io, strutils, strformat, sequtils, algorithm, sets, streams

type
  Vector = tuple
    x, y: int

var
  unique = initHashSet[Vector]()
  snake: seq[Vector]

proc initSnake(x: int) =
  if snake.len > 0:
    snake.setLen(0)

  for i in 0..x-1:
    snake.add((0, 0))

  unique.clear
  unique.incl((0, 0))

proc sign(x: int): int =
  (x > 0).int - (x < 0).int
 
proc `-`(left, right: Vector): Vector =
  (left.x - right.x, left.y - right.y)

proc `+=`(left: var Vector, right: Vector) =
  left.x += right.x
  left.y += right.y

proc `$`(vector: Vector): string =
  "(" & $vector.x & "," & $vector.y & ")"

proc moveRequired(vector: Vector): bool =
  vector.x.abs == 2 or vector.y.abs == 2

proc moveBody() =
  for i in 0..snake.len-2:
    let difference = snake[i] - snake[i+1]
    var step: Vector

    if difference.moveRequired:
      if difference.x.abs == 2 and difference.y.abs == 2:
        step = (1 * difference.x.sign, 1 * difference.y.sign)
      elif difference.x.abs == 2:
        step = (1 * difference.x.sign, difference.y)
      else:
        step = (difference.x, difference.y.sign)
    else:
      return

    snake[i+1] += step
    if i+1 == snake.len-1:
      unique.incl(snake[i+1])

proc moveHead(vector: Vector) =
  let 
    counter =
      if vector.x == 0: vector.y
      else: vector.x
    step: Vector = 
      if vector.x == 0: (0, 1 * counter.sign)
      else: (1 * counter.sign, 0)

  for i in 1..counter.abs:
    snake[0] += step
    moveBody()

proc translateMove(move: seq[string]): Vector =
  var distance = move[1].parseInt
  
  case move[0]:
  of "R": result.x = distance
  of "L": result.x = distance * -1
  of "U": result.y = distance
  of "D": result.y = distance * -1

proc moveSnake(moves: seq[seq[string]]) =
  for i, move in moves:
    var vector = move.translateMove()
    moveHead(vector)
    
var
  file = open("data/day09.txt", fmRead)
  moves: seq[seq[string]]

when isMainModule:
  while not endOfFile(file):
    moves.add(readLine(file).split)

  #Part 1
  if false:
    initSnake(2)
    moveSnake(moves)
  
    echo fmt"Unique visits (1): {unique.len}"

  #part 2
  if true:
    initSnake(10)
    moveSnake(moves)

    echo fmt"Unique visits (2): {unique.len}"
   
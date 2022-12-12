import system/io, strutils, strformat, sequtils, regex, algorithm

type
  MonkeyOp = object
    operand, value: string

  Monkey = object
    test, inspections: int
    items: seq[int]
    op: MonkeyOp
    targets: (int, int)

proc test(dividend, divisor: int): bool =
  dividend mod divisor == 0

proc evaluate(op: MonkeyOp, old: int): int =
  let n =
    if op.value == "old": old
    else: op.value.parseInt

  case op.operand:
  of "+": result = old + n
  of "*": result = old * n
  else: discard

proc popFirst(s: var seq[int]): int =
  result = s[0]
  s.delete(0)

proc parseInts(s: string): seq[int] =
  s.findAndCaptureAll(re"-?\d+").map(parseInt)

proc runRounds(m: var seq[Monkey], divisor: int) =
  let worryDrop = m.mapIt(it.test).foldl(a*b)
  
  for i in 0..m.high:
    while m[i].items.len > 0:
      var item = m[i].items.popFirst()

      m[i].inspections.inc
      item = m[i].op.evaluate(item)
      item = item div divisor
      item = item mod worryDrop

      let destination = 
        if item.test(m[i].test): m[i].targets[0]
        else: m[i].targets[1]

      m[destination].items.add(item)

proc throwPoop(m: seq[Monkey], rounds, divisor: int) =
  var ms = m
  
  for i in 0..rounds-1:
    ms.runRounds(divisor)

  var inspections = ms.mapIt(it.inspections)
  inspections.sort

  var total = inspections[^2..^1].foldl(a*b)
  echo fmt"Total inspections of top 2 most active monkeys: {total}"

proc parseMonkeyBusiness(): seq[Monkey] =
  var
    monkeyBusiness = readFile("data/day11.txt").split("\r\n\r\n")

  for business in monkeyBusiness:
    var
      lines = business.splitLines()
      monkey: Monkey

    monkey.test = lines[3].parseInts[0]
    monkey.items = lines[1].split(":")[1].split(",").mapIt(it.strip.parseInt).toSeq
    monkey.op.operand = lines[2].split("=")[1].split[2].strip
    monkey.op.value = lines[2].split("=")[1].split[3].strip
    monkey.targets[0] = lines[4].parseInts[0]
    monkey.targets[1] = lines[5].parseInts[0]
    
    result.add(monkey)

when isMainModule:
  var monkeys = parseMonkeyBusiness()

  monkeys.throwPoop(20, 3)
  monkeys.throwPoop(10_000, 1)

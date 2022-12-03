import system/io, strutils, sequtils, strformat

var
  caloriesTotal: seq[int]
  count: int
  file = open("data/day01.txt", fmRead);

proc topElf(calories: seq[int]) = 
  let maxIndex = maxIndex(calories)
  echo fmt"Elf #{maxIndex - 1} is holding {caloriesTotal[maxIndex]} calories"

proc topThree(calories: seq[int]) =
  var
    total: int
    calories = calories

  for i in 0..2:
    let maxIndex = maxIndex(calories)
    total += calories[maxIndex]
    calories.delete(maxIndex..maxIndex)

  echo fmt"The top three most laden elves are holding {total} calories"

when isMainModule:
  while not endOfFile(file):
    var line = readLine(file);
    while line.len > 0 and not endOfFile(file):
      count += parseInt(line)
      line = readLine(file)

    caloriesTotal.add(count)
    count = 0

  topElf(caloriesTotal)
  topThree(caloriesTotal)

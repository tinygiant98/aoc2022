# Advent of Code, Day 1, Part 1
# Add blocks of integers

import system/io, strutils, sequtils, strformat

var
  caloriesTotal: seq[int]
  count: int
  file = open(r"H:/projects/aoc2022/data/day1.txt", fmRead);

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

  #Part 1 - Max number of calories being held by any elf
  topElf(caloriesTotal)
  #let maxIndex = maxIndex(caloriesTotal)
  #echo fmt"Elf #{maxIndex - 1} is holding {caloriesTotal[maxIndex]} calories"

  #Part 2 - Total number of calories being helf by the top
  # three elves
  topThree(caloriesTotal)

# Advent of Code, Day 1, Part 1
# Add blocks of integers

import system/io, strutils, strformat, sequtils

proc toPriority(pack: string): seq[int] =
  for item in pack:
    var priority = int(char(item))
    if priority >= 97: priority -= 96
    else: priority -= 38

    result.add(priority)

proc getCommonItem(items: seq[int]): int =
  let
    split = items.len div 2
    left = items[0..split-1]
    right = items[split..^1]

  return left.filterIt(it in right)[0]

proc totalCommonItems(packs: seq[string]) =
  var
    prioritizedPacks: seq[seq[int]]
    total: int

  for pack in packs:
    prioritizedPacks.add(pack.toPriority)

  for pack in prioritizedPacks:
    total += getCommonItem(pack)

  echo fmt"Total of common item priorities: {total}"

proc findBadge(packs: seq[string]): char =
  packs[0].filterIt(it in packs[1] and it in packs[2])[0]

proc totalBadges(packs: seq[string]) =
  var
    group: seq[string]
    prioritizedBadges: seq[int]
    badges: string
    total: int

  for n in 0..packs.len-1:
    group.add(packs[n])
    if (n + 1) mod 3 == 0:
      badges.add(findBadge(group))
      group = @[]

  prioritizedBadges = badges.toPriority()
  total = foldl(prioritizedBadges, a + b)
  echo fmt"Total of badge priorities: {total}"

var
  packs: seq[string]
  file = open("data/day03.txt", fmRead)

when isMainModule:
  while not endOfFile(file):
    var line = readLine(file)
    packs.add(line.split(" "))

  totalCommonItems(packs)
  totalBadges(packs)

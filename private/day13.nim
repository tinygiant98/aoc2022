import system/io, strutils, sequtils, json, algorithm

type
  Pair = tuple[left, right: JsonNode]

var pairs: seq[Pair]

proc isNumeric(j: JsonNode): bool = j.kind == JInt
proc isList(j: JsonNode): bool = j.kind == JArray

proc comp(l, r: JsonNode): int =
  if l.isNumeric:
    if r.isNumeric:
      if l.getInt < r.getInt: return -1
      elif l.getInt > r.getInt: return 1
      else: return 0
    elif r.isList:
      return comp(%[l], r)
  elif l.isList:
    if r.isNumeric:
      return comp(l, %[r])
    elif r.isList:
      if l.len == 0 and r.len > 0: return -1
      elif l.len > 0 and r.len == 0: return 1
      elif l.len == 0 and r.len == 0: return 0

    var 
      left: seq[JsonNode] = l.getElems
      right: seq[JsonNode] = r.getElems

    for index in left.low..left.high:
      if index > right.high: return 1

      result = comp(left[index], right[index])
      if result != 0: break

    if result == 0 and left.high < right.high: return -1

proc parsePackets() =
  var packet = 1

  for line in readFile("data/day13.txt").splitLines:
    if line.len == 0:
      #pairs.add((nil, nil))
      packet = 1
      continue

    if packet == 1: pairs.add((line.parseJson, nil))
    else: pairs[^1].right = line.parseJson

    packet.inc

proc ordered(pair: Pair): int =
  comp(pair.left, pair.right)

when isMainModule:
  parsePackets()

  echo "Indices sum (Part 1): ", countup(pairs.low, pairs.high).toSeq
    .foldl(if pairs[b].ordered == -1: a + b + 1 else: a, 0)

  var packets: seq[JsonNode]

  for packet in pairs:
    packets.add(packet.left)
    packets.add(packet.right)

  packets.add("[[2]]".parseJson)
  packets.add("[[6]]".parseJson)

  packets.sort(comp)

  echo "Indices sum (Part 2): ", countup(packets.low, packets.high).toSeq
    .foldl(if $packets[b] == "[[2]]" or $packets[b] == "[[6]]": a * (b + 1) else: a, 1)

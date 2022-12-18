import strutils, streams, sequtils, npeg

type
  Valve = tuple[valve: string, tunnels: seq[string], rate: int]

var
  valves: seq[Valve]
  distances: seq[seq[int]]

proc readData() =
  let p = peg "valve":
    valve <- *data * *("\r\n" * data)
    data <- "Valve " * >Upper[2] * +blah * >Digit[1..2] * +blah * >tunnels:
      valves.add((capture[1].s, capture[3].s.split(", ").toSeq, capture[2].s.parseInt))
    tunnels <- Upper[2] * *(", " * Upper[2])
    blah <- {'a'..'z',';','=',' '}
  
  let fs = newFileStream("data/day16.txt")
  defer: fs.close

  assert p.match(fs.readAll).ok

  # Populate matrix for floyd-warshall
  for source in valves.low..valves.high:
    distances.add(repeat(1_000_000, valves.len))

    for destination in valves.low..valves.high:
      if source == destination: distances[source][destination] = 0
      if valves[source].tunnels.contains(valves[destination].valve):
        distances[source][destination] = 1

  # Populate distances using floyd-warshall
  for valve in valves.low..valves.high:
    for source in valves.low..valves.high:
      for destination in valves.low..valves.high:
        let distance = distances[source][valve] + distances[valve][destination]
        if distance < distances[source][destination]:
          distances[source][destination] = distance

# Fully lifted from al1ranger - I'm too dumb for this, so I'm using this to learn
proc getMaxPressure(start: seq[int], valvePositions: string, duration: seq[int], currentProcessor: int = 1): int =
  if valvePositions.find('0') == -1:
    return
  
  let processorIdx: int = currentProcessor - 1
    
  if duration[processorIdx] <= 0: return
  
  var
    valveIdx, timeRequired: int
    newValvePositions: string = valvePositions
    newDuration: seq[int] = duration
    pressures: seq[int] = @[0]
    current: seq[int] = start
  
  valveIdx = current[processorIdx]
  
  for idx in valves.low() .. valves.high():
    if valves[idx].rate == 0 or valvePositions[idx] == '1':
      continue
    
    timeRequired = distances[valveIdx][idx] + 1
    if timeRequired >= duration[processorIdx]:
      continue
    
    newValvePositions[idx] = '1'
    current[processorIdx] = idx
    newDuration[processorIdx].dec(timeRequired)
    
    if currentProcessor > 1:
      pressures.add(valves[idx].rate * (duration[processorIdx] - timeRequired) + 
      current.getMaxPressure(newValvePositions, newDuration, processorIdx))
    else:
      pressures.add(valves[idx].rate * (duration[processorIdx] - timeRequired) + 
      current.getMaxPressure(newValvePositions, newDuration, start.len()))
    
    newValvePositions[idx] = '0'
    current[processorIdx] = start[processorIdx]
    newDuration[processorIdx] = duration[processorIdx]
    
  return pressures.max

when isMainModule:
  readData()

  let aa = valves.mapIt(it.valve).find("AA")
  echo "Part 1: ", getMaxPressure(@[aa], repeat('0', valves.len), @[30])
  echo "Part 2: ", getMaxPressure(@[aa,aa], repeat('0', valves.len), @[26,26], 2)

# Maximum pressure release possible for two processors in 26 minutes  
#echo "Part 2: ", maxPressureRelease(@[valveIds.find("AA"), 
#  valveIds.find("AA")], repeat('0', valveIds.len()), @[26, 26], 2)


# https://adventofcode.com/2022/day/17

import os, strutils, sequtils, tables

## Optional parameter to print 
#var
#  printFinalChamber: bool
#
#if os.paramCount() >= 2:
#  try:
#    printFinalChamber = os.paramStr(2).parseBool()
#  except ValueError:
#    printFinalChamber = false

# This is basically a simplified Tetris simulation with rotation removed. The
# sub-reddit provides useful tips for modeling as well as for optimizing part 2
# https://www.reddit.com/r/adventofcode/comments/znykq2/2022_day_17_solutions/

# We will use bit manipulations for the simulations.

type
  Block = array[4, uint8]

let
  jets: string = readFile("data/day17.txt").strip().splitLines[0]
  # The blocks as array of integers
  blocks: array[5, Block] = [
  [0b00000000'u8,
   0b00000000'u8,
   0b00000000'u8,
   0b00111100'u8],
  [0b00000000'u8,
   0b00010000'u8,
   0b00111000'u8,
   0b00010000'u8],
  [0b00000000'u8,
   0b00001000'u8,
   0b00001000'u8,
   0b00111000'u8],
  [0b00100000'u8,
   0b00100000'u8,
   0b00100000'u8,
   0b00100000'u8],
  [0b00000000'u8,
   0b00000000'u8,
   0b00110000'u8,
   0b00110000'u8]]
   
var
  nextRockIdx: int = 0
  nextJetIdx: int = 0
  rockY: int = 0
  chamberY: int64 = 0
  image: seq[uint8] = @[]

# Performs exclusive or (XOR) of the rock image on the chamber image. Because 
# of the nature of the XOR operation, the rock image will be removed if it 
# exists and added if it is absent
proc xorPut(chamber: var seq[uint8], image: seq[uint8]) =
  if chamber.low() != image.low() or chamber.high() != image.high():
    return
  
  for i in image.low() .. image.high():
    chamber[i] = chamber[i] xor image[i]

# Prints the chamber
proc print(chamber: seq[uint8]) =
  var
    chamberCopy: seq[uint8] = chamber
  
  chamberCopy.xorPut(image)
  echo repeat('-', 7)
  for row in chamberCopy:
    echo row.int().toBin(8)[0 .. 6].replace('1', '#').replace('0', '.')
  echo repeat('-', 7)
  chamberCopy.xorPut(image)

# Adds the next rock to the chamber. Shifts the visible area of the chamber if
# required. Updates the Y co-ordinate of the lowermost row of the chamber, the
# next rock that is required and sets the position of the bottom row of the
proc addRock(chamber: var seq[uint8]) =
  rockY = -1
  
  var
    startRow: int
  
  # Initialize the image
  image = repeat(0'u8, chamber.len())
  
  # Locate the topmost row in the chamber that is occupied. The new rock will 
  # begin four units above that.
  for row in chamber.low() .. chamber.high():
    if chamber[row] > 1'u8:
      startRow = row - 4
      break
  
  # Adjust the visible area so that the new rock is also visible
  while startRow < blocks[nextRockIdx].high():
    chamber.delete(chamber.high())
    chamber.insert(0, 1'u8)
    chamberY.inc()
    startRow.inc()      
  
  # Initialize the image
  rockY = startRow      
  for row in countdown(blocks[nextRockIdx].high(), blocks[nextRockIdx].low()):
    image[startRow] = blocks[nextRockIdx][row]
    startRow.dec()  
  
  nextRockIdx.inc()
  if nextRockIdx > blocks.high():
    nextRockIdx = blocks.low()

# Simulates rocks getting pushed by jet. Returns the next jet id.
proc pushByJet(image: var seq[uint8]): int =
  result = nextJetIdx
  
  block doPush:
    # Check direction of jet
    case jets[result]
      of '>':
        # Check whether movement is possible
        for delta in 0 .. 3:
          if (image[rockY - delta] and 2'u8) == 2'u8:
            break doPush
        
        # Perform the movement
        for delta in 0 .. 3:
          image[rockY - delta] = image[rockY - delta].shr(1'u8)
          
      of '<':
        # Check whether movement is possible
        for delta in 0 .. 3:
          if (image[rockY - delta] and 128'u8) == 128'u8:
            break doPush
        
        # Perform the movement
        for delta in 0 .. 3:
          image[rockY - delta] = image[rockY - delta].shl(1'u8)
        
      else:
        discard
  
  # Return the next jet id
  result.inc()
  if result > jets.high():
    result = jets.low()

# Simulates falling down by 1 unit. Returns the next Y co-ordinate of the image
# where the base of the rock is present.
proc fallDown(image: var seq[uint8]): int =  
  result = rockY
  
  # Update the Y co-ordinate
  if result < image.high():
    result.inc()
  
  # Shift down
  image.delete(image.high())
  image.insert(0'u8, 0)

# Checks whether the image collides with rocks or chamber boundaries. If any 
# collision is detected, the position is not updated. Returns false when 
# downward movement is not possible.
proc checkCollision(chamber: seq[uint8], image: seq[uint8], rockY: int): bool =
  result = true
  
  # The rock images are maximum four rows high
  for delta in 0 .. 3:
    var
      chamberRow: uint8
    
    # Get the chamber row for the image position
    chamberRow = chamber[rockY - delta]
    
    # Ignore empty rows. The last bit is set to 1 because the chamber width is 7.
    if chamberRow == 1'u8:
      continue
    
    # Set the bits corresponding to the same row of image 
    chamberRow = chamberRow or image[rockY - delta]
    
    # Use XOR to clear the bits set from the chamber
    chamberRow = chamber[rockY - delta] xor chamberRow
    
    # Check whether the set bits in the processed row and image are identical
    if chamberRow != image[rockY - delta]:
      result = false
      break

# Simulates movement and updates state if movement is possible
proc checkAndMove(chamber: var seq[uint8]): bool =
  result = false
  
  var
    imageCopy: seq[uint8]
    newJetId, newRockY, emptyRows: int
  
  # If image has no data, then no processing is needed
  emptyRows = 0
  for delta in 0 .. 3:
    if image[rockY - delta] == 0'u8:
      emptyRows.inc()
  
  if emptyRows == 4:
    return
  
  imageCopy = image
  newJetId = nextJetIdx
  newRockY = rockY
  
  # Check if pushing by jet is possible
  newJetId = imageCopy.pushByJet()
  if chamber.checkCollision(imageCopy, rockY):
    image = imageCopy
  else:
    imageCopy = image
    
  # The jet id is always updated  
  nextJetIdx = newJetId
  
  # Check whether falling down is possible
  newRockY = imageCopy.fallDown()
  if not chamber.checkCollision(imageCopy, newRockY):
    # Add the rock image to the chamber image
    chamber.xorPut(image)
    return
  
  # Update state if falling down is possible  
  result = true
  image = imageCopy
  rockY = newRockY

var
  parts: int64 = 0
  # The rightmost bit needs to be set as chamber width is 7
  chamber: seq[uint8] = repeat(1'u8, 49)

chamber.add(255'u8)
chamber.addRock()

# Height after 2022 rocks have fallen
block part1:    
  while parts < 2022:
    if not chamber.checkAndMove():
      parts.inc()
      chamber.addRock()
  
  #if printFinalChamber:
  chamber.print()
  
  # chamberY is the Y co-ordinate for the base of the chamber, and the sequence 
  # index is chamber.high(). The block starts 4 units above the highest row 
  # with rocks, i.e rockY + 4 is the required index in the sequence
  echo "Part 1: ", chamberY + (chamber.high() - (rockY + 4))

# Height after 1000000000000 rocks have fallen
#
# As mentioned in the sub-reddit, the combination of rock to be added and the 
# jet that will immediately act on ot repeats. This can be used to speed up
# calculation for part 2.
block part2:  
  var
    cache: Table[string, tuple[blocks: int64, chamberY: int64]] = 
      initTable[string, tuple[blocks: int64, chamberY: int64]]()
    key: string
  
  while parts < 1000000000000:
    if not chamber.checkAndMove():
      parts.inc()
      
      # Build the key and check whether it is a repeat scenario. Store the 
      # non-existent key for future comparisons  
      key = $nextJetIdx & "_" & $nextRockIdx
      if cache.hasKey(key):
        # Use the data to skip repetitive cycles
        var
          cycles, deltaRocks, deltaHeight: int64
        
        # Differences between this and the cached occurrence
        deltaRocks = parts - cache[key].blocks
        deltaHeight = chamberY - cache[key].chamberY
        
        # Calculate cycles to be skipped
        cycles = (1000000000000 - parts) div deltaRocks
        
        # Update the part count and Y co-ordinate
        parts += (cycles * deltaRocks)
        chamberY += (cycles * deltaHeight)
      else:
        cache[key] = (blocks: parts, chamberY: chamberY)
      
      chamber.addRock()
    
  #if printFinalChamber:
  chamber.print()
  
  echo "Part 2: ", chamberY + (chamber.high() - (rockY + 4))

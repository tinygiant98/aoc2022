# https://adventofcode.com/2022/day/19

import os, strutils, strscans, sugar, sequtils, math, strformat

type
  BluePrint = tuple[id, oreRobotOreCost, clayRobotOreCost, obsidianRobotOreCost, 
    obsidianRobotClayCost, geodeRobotOreCost, geodeRobotObsidianCost: int]

var
  blueprints: seq[BluePrint] = @[]
  
block readInput:
  var
    blueprint: BluePrint
  
  for line in readFile("data/day19.txt").strip().splitLines():
    if line.scanf("Blueprint $i: Each ore robot costs $i ore. " & 
      "Each clay robot costs $i ore. Each obsidian robot costs $i ore and $i " & 
      "clay. Each geode robot costs $i ore and $i obsidian.", 
      blueprint.id, blueprint.oreRobotOreCost, blueprint.clayRobotOreCost,
      blueprint.obsidianRobotOreCost, blueprint.obsidianRobotClayCost,
      blueprint.geodeRobotOreCost, blueprint.geodeRobotObsidianCost):
      blueprints.add(blueprint)

# Because of the explosion of alternatives at each step, a recursive search will
# fail even for the example data. So, other approaches are required.
# https://www.reddit.com/r/adventofcode/comments/zpihwi/2022_day_19_solutions/
type
  State = tuple[oreRobots, clayRobots, obsidianRobots, geodeRobots, ore, 
    clay, obsidian, geode, minutes: int]

proc getGeodesOpened(blueprint: BluePrint, input: State): int =
  result = 0
  
  var
    statesToCheck: seq[State] = @[input]
    maxGeodes: seq[int] = repeat(0, input.minutes)
    maxOreForNonOreRobot: int
  
  maxOreForNonOreRobot = [blueprint.obsidianRobotOreCost, 
    blueprint.geodeRobotOreCost, blueprint.clayRobotOreCost].max()    
    
  while statesToCheck.len() > 0:
    
    var
      state, currentState, tempState: State
    
    state = statesToCheck[0]
    statesToCheck.delete(0)
    
    currentState = state
    
    # Update the raw materials
    state.ore.inc(state.oreRobots)
    state.clay.inc(state.clayRobots)
    state.obsidian.inc(state.obsidianRobots)
    state.geode.inc(state.geodeRobots)
    state.minutes.dec()
    
    if maxGeodes[state.minutes] > state.geode:
      continue
        
    maxGeodes[state.minutes] = state.geode
    
    if state.minutes == 0:
      if state.geode > result:
        result = state.geode
      continue       
    
    # Build robots if enough raw materials are available
    if currentState.obsidian >= blueprint.geodeRobotObsidianCost and
      currentState.ore >= blueprint.geodeRobotOreCost:
      tempState = state
      tempState.geodeRobots.inc()
      tempState.obsidian.dec(blueprint.geodeRobotObsidianCost)
      tempState.ore.dec(blueprint.geodeRobotOreCost)
      statesToCheck.add(tempState)
      continue
    
    if currentState.ore >= blueprint.obsidianRobotOreCost and 
      currentState.clay >= blueprint.obsidianRobotClayCost and 
      currentState.obsidianRobots < blueprint.geodeRobotObsidianCost:
      tempState = state
      tempState.obsidianRobots.inc()
      tempState.ore.dec(blueprint.obsidianRobotOreCost)
      tempState.clay.dec(blueprint.obsidianRobotClayCost)
      statesToCheck.add(tempState)
      continue
    
    if currentState.ore >= blueprint.oreRobotOreCost and 
      currentState.oreRobots < maxOreForNonOreRobot:
      tempState = state
      tempState.oreRobots.inc()
      tempState.ore.dec(blueprint.oreRobotOreCost)
      statesToCheck.add(tempState)
      #continue
      
    if currentState.ore >= blueprint.clayRobotOreCost and 
      currentState.clayRobots < blueprint.obsidianRobotClayCost:
      tempState = state
      tempState.clayRobots.inc()
      tempState.ore.dec(blueprint.clayRobotOreCost)
      statesToCheck.add(tempState)
      #continue
    
    # No robots built this step -> For part 2, this works for test data but 
    # not for the puzzle input
    if currentState.oreRobots + currentState.ore < maxOreForNonOreRobot + 
      blueprint.oreRobotOreCost:
      statesToCheck.add(state)

when isMainModule:
  block part1:  
    let geodes = collect(newSeq):
      for blueprint in blueprints:
        echo fmt"Working blueprint {blueprint.id}"
        blueprint.id * blueprint.getGeodesOpened((oreRobots: 1, clayRobots: 0, 
          obsidianRobots: 0, geodeRobots: 0, ore: 0, clay: 0, obsidian: 0, 
          geode: 0, minutes: 24))
    
    echo "Part 1: ", geodes.sum()

  # Not working at present
  block part2:
    var geodes = collect(newSeq):
      for blueprintIdx in 0 .. min(blueprints.high(), 2):
        blueprints[blueprintIdx].getGeodesOpened((oreRobots: 1, clayRobots: 0, 
          obsidianRobots: 0, geodeRobots: 0, ore: 0, clay: 0, obsidian: 0, 
          geode: 0, minutes: 32))
    
    echo "Part 2: ", geodes.prod()

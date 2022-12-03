import system/io, strutils, strformat, sequtils

var
  plays: seq[seq[string]]
  file = open("data/day02.txt", fmRead);

proc scoreGame(plays: seq[seq[string]]) =
  var
    score: int 
    hand: int

  for play in plays:
    inc hand
    if play[1] == "X": score += 1
    elif play[1] == "Y": score += 2
    elif play[1] == "Z": score += 3

    if play[1] == "X" and play[0] == "C": score += 6
    elif play[1] == "Y" and play[0] == "A": score += 6
    elif play[1] == "Z" and play[0] == "B": score += 6
    elif play[1] == "X" and play[0] == "A": score += 3
    elif play[1] == "Y" and play[0] == "B": score += 3
    elif play[1] == "Z" and play[0] == "C": score += 3

  echo fmt"Score: {score}"

proc getPlay(play: seq[string]): seq[string] =
  var
    opponent = play[0]
    require = play[1]
    need: string
    final: seq[string]

  case require:
    of "X":
      if opponent == "A": need = "Z"
      elif opponent == "B": need = "X"
      elif opponent == "C": need = "Y"
    of "Y":
      if opponent == "A": need = "X"
      elif opponent == "B": need = "Y"
      elif opponent == "C": need = "Z"
    of "Z":
      if opponent == "A": need = "Y"
      elif opponent == "B": need = "Z"
      elif opponent == "C": need = "X"
    else: discard
      
  final.add(@[opponent, need])
  return final

proc fixGame(plays: seq[seq[string]]) =
  var
    plays = plays.mapIt(getPlay(it))

  scoreGame(plays)

when isMainModule:
  while not endOfFile(file):
    var line = readLine(file);
    plays.add(line.split(" "));

  scoreGame(plays)
  fixGame(plays)







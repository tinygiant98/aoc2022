import strutils, strformat, tables, streams, strscans

type
  Folder = ref object
    children: Table[string, Folder]
    parent: Folder
    size: int

proc sumSmall(folders: Folder): int =
  for path, folder in folders.children.pairs:
    if folder.size <= 100_000:
      result.inc folder.size
    
    result.inc sumSmall(folder)

proc findSacrifice(folders: Folder, goal: int = 0): int =
  let goal = 
    if goal == 0: 30_000_000 - (70_000_000 - folders.size)
    else: goal

  result = int.high
  for path, folder in folders.children.pairs:
    if folder.size >= goal:
      result = min(folder.size, result)

    result = min(findSacrifice(folder, goal), result)

proc propogateSize(folder: Folder, size: int) =
  var parent = folder.parent
  while parent != nil:
    parent.size += size
    parent = parent.parent

proc buildFolders(): Folder =
  result = Folder()

  var
    currentFolder = result
    commandBuffer, nameBuffer: string

  let fs = newFileStream("data/day07.txt")
  defer: fs.close

  while not fs.atEnd():
    let command = fs.readLine
    if command == "$ ls":
      while not fs.atEnd() and fs.peekChar != '$':
        var size: int
        
        discard fs.readLine(commandBuffer)
        if commandBuffer.scanf("dir $+", nameBuffer):
          currentFolder.children[nameBuffer] = Folder(parent: currentFolder)
        elif commandBuffer.scanf("$i $+", size, nameBuffer):
          currentFolder.size += size
          currentFolder.propogateSize(size)
        else:
          discard
    elif command.scanf("$$ cd $+", nameBuffer):
      case nameBuffer:
      of "..":
        if currentFolder.parent != nil:
          currentFolder = currentFolder.parent
        else:
          currentFolder = result
      of "/":
        currentFolder = result
      else:
        if nameBuffer in currentFolder.children:
          currentFolder = currentFolder.children[nameBuffer]

when isMainModule:
  let folders = buildFolders()

  echo fmt"Sum of all folders <= 100,000: {sumSmall(folders)}"
  echo fmt"Size of sacrifical folder: {findSacrifice(folders)}"


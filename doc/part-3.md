## Part 3: Generating a Dungeon

Tutorial link [SelinaDev Godot 4: Part 3](https://selinadev.github.io/07-rogueliketutorial-03/)

Dungeon Generation. Here I plan on expanding a bit on my own. I think I'd like to genererate a dungeon based on premade and/or random cells, a bit like Diablo, instead of the basic cut out a lot of rooms and string them up on corridors.

### First attempt

Create a maze from random depth first search. These are the cells. Then work from there.

First implementation of a cell would be a open room with a 1 tile opening to each open side of the cell.

First generated dungeon is a 2x2 cell dungeon with 9x5 tile cell. Hardcoded to a C form.

### Improvement

Implemented a random DFS with any size cell dungeon. Could also experiment with different room shapes.

Set start cell to walk from to be set from player position, or random if player has no position. Player is set to middle of start cell, expect stair to be in the middle.

Implementing the camera to follow player was a great help with the big tiles, so I also increased the size of the dungeon to 66 x 28 (6x4 cells with 11x7 rooms).

### Notes

I've followed the greater lines of the tutorial, though I generate the dungeon differently. I've also made a bit of a mess in the code. That will need to be cleared up.

The size of the cells and dungeon will definetly have to be adjusted. I'll have to create some different rooms (random and/or hard coded) and see what feels good.

A map view and a pan functionality will be nice to have with time.

### Prefabs

I'm doing this not quick, but dirty. I'm storing room metadata in text files, and the map layout in pngs. Small rooms can be rotated to fit.

Currently I'm placing one big (2x2) if I can find a place for it. It is still a bit of a hack; the room needs two horisontal corridors, and will not rotate. There also is only one big room. It also tries every cell until it finds a place for a big room, or dungeon is generated.
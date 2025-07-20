## Part 3: Generating a Dungeon

Tutorial link [SelinaDev Godot 4: Part 3](https://selinadev.github.io/07-rogueliketutorial-03/)

Dungeon Generation. Here I plan on expanding a bit on my own. I think I'd like to genererate a dungeon based on premade and/or random cells, a bit like Diablo, instead of the basic cut out a lot of rooms and string them up on corridors.

### First attempt

Create a maze from random depth first search. These are the cells. Then work from there.

First implementation of a cell would be a open room with a 1 tile opening to each open side of the cell.

First generated dungeon is a 2x2 cell dungeon with 9x5 tile cell. Hardcoded to a C form
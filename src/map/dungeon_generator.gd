class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 2
@export var map_height: int = 2
@export var cell_width: int = 9
@export var cell_height: int = 5

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	_rng.randomize()

func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.floor)

func _carve_cell(dungeon: MapData, cell: Cell, cx: int, cy: int) -> void:
	var room := Rect2i(cx*cell_width, cy*cell_height, cell_width, cell_height)
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y):
		for x in range(inner.position.x, inner.end.x):
				_carve_tile(dungeon, x, y)
	if cell.north:
		_carve_tile(dungeon, (cx*cell_width)+(cell_width/2),(cy*cell_height) )
	if cell.south:
		_carve_tile(dungeon, (cx*cell_width)+(cell_width/2),(cy*cell_height)+cell_height-1 )
	if cell.east:
		_carve_tile(dungeon, (cx*cell_width)+cell_width-1, (cy*cell_height)+(cell_height/2))
	if cell.west:
		_carve_tile(dungeon, (cx*cell_width), (cy*cell_height)+(cell_height/2))

func _generateStaticMaze(maze: MazeData) -> void:
	maze.cells[0].east = true
	maze.cells[0].south = true
	maze.cells[1].west = true
	maze.cells[2].north = true
	maze.cells[2].east = true
	maze.cells[3].west = true

func _generateMaze(maze: MazeData, startpos: Vector2i) -> void:
	var firstCell := maze.get_cell(startpos)
	_visitCell(firstCell, maze)

func _visitCell(cell: Cell, maze: MazeData) -> void:
	cell.seen = true
	var next := _getNextCell(maze.getNewNeighbours(cell))
	while next != null:
		_removeWalls(cell, next)
		_visitCell(next, maze)
		next = _getNextCell(maze.getNewNeighbours(cell))

func _removeWalls(cell: Cell, next: Cell) -> void:
	if cell.position.x == next.position.x:
		if cell.position.y > next.position.y:
			cell.north = true
			next.south = true
		else:
			cell.south = true
			next.north = true
	else:
		if cell.position.x > next.position.x:
			cell.west = true
			next.east = true
		else:
			cell.east = true
			next.west = true


func _getNextCell(cand: Array[Cell]) -> Cell:
	if cand.is_empty():
		return null
	return cand.get(_rng.randi_range(0, cand.size()-1))

func generate_dungeon(player: Entity) -> MapData:
	var maze := MazeData.new(map_width, map_height)
	#_generateStaticMaze(maze)
	
	var startCellPos: Vector2i
	if player.grid_position == Vector2i.MIN:
		startCellPos = maze.cells[randi_range(0, maze.cells.size() - 1)].position
		print("Randomized start to cell: ", startCellPos)
	else:
		startCellPos = Vector2i( player.grid_position.x / cell_width, player.grid_position.y / cell_height)
		print("Got pos: ", player.grid_position, " set start cell to: ", startCellPos)
	
	_generateMaze(maze, startCellPos)

	var dungeon := MapData.new(map_width*cell_width, map_height*cell_height)
	
	for y in map_height:
		for x in map_width:
			_carve_cell(dungeon, maze.get_cell(Vector2i(x, y)), x, y)
	
	player.grid_position = Vector2i((startCellPos.x*cell_width) + (cell_width/2), (startCellPos.y*cell_height) + (cell_height/2))
	
	return dungeon

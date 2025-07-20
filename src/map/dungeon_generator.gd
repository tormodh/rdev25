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

func generate_dungeon() -> MapData:
	var maze := MazeData.new(map_width, map_height)
	_generateStaticMaze(maze)
	
	var dungeon := MapData.new(map_width*cell_width, map_height*cell_height)
	
	for yy in map_height:
		for xx in map_width:
			_carve_cell(dungeon, maze.get_cell(Vector2i(xx, yy)), xx, yy)
	
	return dungeon

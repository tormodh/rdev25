class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 2
@export var map_height: int = 2
@export var cell_width: int = 9
@export var cell_height: int = 5

var _rng := RandomNumberGenerator.new()
var cells: Array[Cell]


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

func generate_dungeon() -> MapData:
	var dungeon := MapData.new(map_width*cell_width, map_height*cell_height)
	
	#for yy in map_height:
	#	for xx in map_width:
	#		cells.append(Cell.new())
	
	cells.append(Cell.new())
	cells.append(Cell.new())
	cells.append(Cell.new())
	cells.append(Cell.new())
	
	cells[0].east = true
	cells[0].south = true
	cells[1].west = true
	cells[2].north = true
	cells[2].east = true
	cells[3].west = true
	
	for yy in map_height:
		for xx in map_width:
			_carve_cell(dungeon, get_cell(Vector2i(xx, yy)), xx, yy)
	
	return dungeon

func get_cell(cell_position: Vector2i) -> Cell:
	var cell_index: int = cellGrid_to_index(cell_position)
	if cell_index == -1:
		return null
	return cells[cell_index]

func cellGrid_to_index(cell_position: Vector2i) -> int:
	if not is_in_cell_bounds(cell_position):
		return -1
	return cell_position.y * map_width + cell_position.x

func is_in_cell_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < cell_width
		and 0 <= coordinate.y
		and coordinate.y < cell_height
	)

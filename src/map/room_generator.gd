class_name RoomGenerator
extends RefCounted

@warning_ignore_start("integer_division","narrowing_conversion")

func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.floor)

func _block_tile(dungeon: MapData, x: int, y: int) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(dungeon.tile_types.wall)

func createSimpleRoom(cell: Cell, dungeon: MapData) -> void:
	var room := Rect2i(cell.position.x*Cell.cell_width, cell.position.y*Cell.cell_height, Cell.cell_width, Cell.cell_height)
	var inner: Rect2i = room.grow(-1)
	for y in range(inner.position.y, inner.end.y):
		for x in range(inner.position.x, inner.end.x):
				_carve_tile(dungeon, x, y)
	if cell.north:
		_carve_tile(dungeon, (cell.position.x*Cell.cell_width)+(Cell.cell_width/2),(cell.position.y*Cell.cell_height) )
	if cell.south:
		_carve_tile(dungeon, (cell.position.x*Cell.cell_width)+(Cell.cell_width/2),(cell.position.y*Cell.cell_height)+Cell.cell_height-1 )
	if cell.east:
		_carve_tile(dungeon, (cell.position.x*Cell.cell_width)+Cell.cell_width-1, (cell.position.y*Cell.cell_height)+(Cell.cell_height/2))
	if cell.west:
		_carve_tile(dungeon, (cell.position.x*Cell.cell_width), (cell.position.y*Cell.cell_height)+(Cell.cell_height/2))

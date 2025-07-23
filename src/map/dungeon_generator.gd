class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 6
@export var map_height: int = 4

var _rng := RandomNumberGenerator.new()

func _ready() -> void:
	#_rng.randomize()
	_rng.seed = hash("Question")

func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
	_carve_tile_spec(dungeon, x, y, dungeon.tile_types.floor)

func _carve_tile_spec(dungeon: MapData, x: int, y: int, td: TileDefinition) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(td)

func _generateMaze(maze: MazeData, startpos: Vector2i) -> void:
	var firstCell := maze.get_cell(startpos)
	firstCell.room_type = Room.UP
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
			cell.open_wall(0)
			next.open_wall(2)
		else:
			cell.open_wall(2)
			next.open_wall(0)
	else:
		if cell.position.x > next.position.x:
			cell.open_wall(3)
			next.open_wall(1)
		else:
			cell.open_wall(1)
			next.open_wall(3)


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
		startCellPos = Vector2i( player.grid_position.x / Cell.cell_width, player.grid_position.y / Cell.cell_height)
		print("Got pos: ", player.grid_position, " set start cell to: ", startCellPos)
	
	_generateMaze(maze, startCellPos)

	var dungeon := MapData.new(map_width*Cell.cell_width, map_height*Cell.cell_height)
	var roomGenerator := RoomGenerator.new()
	var roomLoader := RoomLoader.new()
	var rnds: Array[int]
	
	for y in map_height:
		for x in map_width:
			var cell = maze.get_cell(Vector2i(x, y))
			if !cell.done:
				cell.done = true
				cell.calculate_dir()
				var room := roomLoader.getRoom(cell)
				if room != null:
					_carveRoom(cell, room, dungeon)
				else:
					var rnd = _rng.randi_range(0,3)
					rnds.append(rnd)
					if rnd < 1:
						roomGenerator.createSmallSimpleRoom(cell, dungeon)
					else:
						roomGenerator.createSimpleRoom(cell, dungeon)
	
	player.grid_position = Vector2i((startCellPos.x*Cell.cell_width) + (Cell.cell_width/2), (startCellPos.y*Cell.cell_height) + (Cell.cell_height/2))
	
	return dungeon

func _carveRoom(cell: Cell, room: Room, dungeon: MapData) -> void:
	room.line_up(cell)
	var blueprint := room.image
	var data := blueprint.get_data()
	for y in range(Cell.cell_height):
		for x in range(Cell.cell_width):
			if data[(y*Cell.cell_width+x)*3] > 0:
				_carve_tile_spec(dungeon, (cell.position.x*Cell.cell_width+x), (cell.position.y*Cell.cell_height+y), dungeon.tile_types.floor)
			else:
				_carve_tile_spec(dungeon, (cell.position.x*Cell.cell_width+x), (cell.position.y*Cell.cell_height+y), dungeon.tile_types.wall)

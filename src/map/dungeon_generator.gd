class_name DungeonGenerator
extends Node

@export_category("Map Dimensions")
@export var map_width: int = 6
@export var map_height: int = 4
@warning_ignore_start("integer_division","narrowing_conversion")

var _rng := RandomNumberGenerator.new()

var _big_candidates: Dictionary[Vector2i, bool]

func _ready() -> void:
	#_rng.randomize()
	_rng.seed = hash("Question")

func generate_dungeon(player: Entity) -> MapData:
	var maze := MazeData.new(map_width, map_height)
	var startCellPos: Vector2i
	if player.grid_position == Vector2i.MIN:
		startCellPos = maze.cells[randi_range(0, maze.cells.size() - 1)].position
		print("Randomized start to cell: ", startCellPos)
	else:
		@warning_ignore("integer_division")
		startCellPos = Vector2i( player.grid_position.x / Cell.cell_width, player.grid_position.y / Cell.cell_height)
		print("Got pos: ", player.grid_position, " set start cell to: ", startCellPos)
	
	var dungeon := MapData.new(map_width*Cell.cell_width, map_height*Cell.cell_height)
	player.grid_position = Vector2i((startCellPos.x*Cell.cell_width) + (Cell.cell_width/2), (startCellPos.y*Cell.cell_height) + (Cell.cell_height/2))
	dungeon.entities.append(player)
	
	_big_candidates.clear()
	for y in range(map_height-1):
		for x in range(map_width-1):
			_big_candidates[Vector2i(x, y)] = true
	
	_generateMaze(maze, startCellPos)
	for cell in maze.cells: cell.calculate_dir()
	_printMaze_Debug(maze)
	
	var roomLoader := RoomLoader.new()
	
	_placeBigRooms(maze, dungeon, roomLoader)
	_printMaze_Debug(maze)

	var roomGenerator := RoomGenerator.new()
	
	for y in map_height:
		for x in map_width:
			var cell = maze.get_cell(Vector2i(x, y))
			if !cell.done:
				cell.done = true
				var cands := roomLoader.getRooms(cell.room_type)
				if (cands != null && !cands.is_empty()):
					var room: Room = cands.get(_rng.randi_range(0, cands.size()-1))
					_carveRoom(cell, room, dungeon)
				else:
					roomGenerator.createSimpleRoom(cell, dungeon)
	
	return dungeon

func _placeBigRooms(maze: MazeData, dungeon: MapData, roomLoader: RoomLoader):
	var numberOfRoomsToTry := ((map_height * map_width) / 4) / 2
	if Debug.MAZE_GENERATION_MSG: print("MAZE_GENERATION: ", "Attempt ", numberOfRoomsToTry, " big rooms. There are ", _big_candidates.keys().size(), " candidates")
	for i in range(numberOfRoomsToTry):
		var cell_index := _rng.randi_range(0, _big_candidates.keys().size()-1)
		var cell_pos: Vector2i = _big_candidates.keys()[cell_index]
		_remove_big_candidate(cell_pos, 2)
		_mark_cells_as_part_of_room(maze, cell_pos, 2) #TODO: method on MazeData
		if Debug.MAZE_GENERATION_TRACE: print("MAZE_GENERATION: ", "Room ", i, " at ", cell_pos, ". There are ", _big_candidates.keys().size() , " candidates left")
		var big_room_type = _calc_big_room_type(maze, cell_pos)
		var big_room_type_min = _calc_min_type(big_room_type)
		var cell := maze.get_cell(cell_pos)
		var cands := roomLoader.getRooms(big_room_type<<4)
		if (cands == null || cands.is_empty()):
			if Debug.MAZE_GENERATION_MSG: print("MAZE_GENERATION: ", "Require big room type ", String.num_int64(big_room_type).lpad(3), " min ( ", String.num_int64(big_room_type_min).lpad(3), " :: ", String.num_int64(big_room_type_min, 2).lpad(8, "0"), " ) key ( ", String.num_int64(big_room_type_min<<4).lpad(4), " )")
			continue
		var room: Room = cands.get(_rng.randi_range(0, cands.size()-1))
		_carveBigRoom(cell, room, dungeon)
		cell.done = true
		maze.get_cell(Vector2i(cell_pos.x, cell_pos.y+1)).done = true
		maze.get_cell(Vector2i(cell_pos.x+1, cell_pos.y+1)).done = true
		maze.get_cell(Vector2i(cell_pos.x+1, cell_pos.y)).done = true


func _calc_big_room_type(maze: MazeData, pos: Vector2i) -> int:
	var type := 0
	var cell = maze.get_cell(pos)
	if cell.north: type += pow(2, 0)
	if cell.west: type += pow(2, 7)
	
	cell = maze.get_cell(Vector2i(pos.x+1, pos.y))
	if cell.north: type += pow(2, 1)
	if cell.east: type += pow(2, 2)
	
	cell = maze.get_cell(Vector2i(pos.x+1, pos.y+1))
	if cell.east: type += pow(2, 3)
	if cell.south: type += pow(2, 4)
	
	cell = maze.get_cell(Vector2i(pos.x, pos.y+1))
	if cell.south: type += pow(2, 5)
	if cell.west: type += pow(2, 6)
	
	return type

func _calc_min_type(type: int) -> int:
	var type1 = type
	var type2 = ((type1 << 2)+(type1>>6)) & 255
	var type3 = ((type2 << 2)+(type2>>6)) & 255
	var type4 = ((type3 << 2)+(type3>>6)) & 255
	return min(type1, type2, type3, type4)

func _mark_cells_as_part_of_room(maze: MazeData, pos: Vector2i, size: int):
	for y in range(pos.y, pos.y + size):
		for x in range(pos.x, pos.x + size):
			maze.get_cell(Vector2i(x, y)).big = true


func _carve_tile(dungeon: MapData, x: int, y: int) -> void:
	_carve_tile_spec(dungeon, x, y, dungeon.tile_types.floor)

func _carve_tile_spec(dungeon: MapData, x: int, y: int, td: TileDefinition) -> void:
	var tile_position = Vector2i(x, y)
	var tile: Tile = dungeon.get_tile(tile_position)
	tile.set_tile_type(td)

func _generateMaze(maze: MazeData, startpos: Vector2i) -> void:
	var firstCell := maze.get_cell(startpos)
	_remove_big_candidate(firstCell.position, 1)
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

func _carveBigRoom(cell: Cell, room: Room, dungeon: MapData):
	var blueprint := room.image
	var data := blueprint.get_data()
	var room_height = Cell.cell_height*2
	var room_width = Cell.cell_width*2
	for y in range(room_height):
		for x in range(room_width):
			if data[(y*room_width+x)*3] > 0:
				_carve_tile_spec(dungeon, (cell.position.x*Cell.cell_width+x), (cell.position.y*Cell.cell_height+y), dungeon.tile_types.floor)
			else:
				_carve_tile_spec(dungeon, (cell.position.x*Cell.cell_width+x), (cell.position.y*Cell.cell_height+y), dungeon.tile_types.wall)
	return

func _carveRoom(cell: Cell, room: Room, dungeon: MapData) -> void:
	var blueprint := room.image
	var data := blueprint.get_data()
	for y in range(Cell.cell_height):
		for x in range(Cell.cell_width):
			if data[(y*Cell.cell_width+x)*3] > 0:
				_carve_tile_spec(dungeon, (cell.position.x*Cell.cell_width+x), (cell.position.y*Cell.cell_height+y), dungeon.tile_types.floor)
			else:
				_carve_tile_spec(dungeon, (cell.position.x*Cell.cell_width+x), (cell.position.y*Cell.cell_height+y), dungeon.tile_types.wall)

func _remove_big_candidate(pos: Vector2i, size: int):
	var rect = Rect2i(pos.x-1, pos.y-1, size+1, size+1)
	for y in range(rect.position.y, rect.end.y):
		if y < 0: continue
		for x in range(rect.position.x, rect.end.x):
			if x < 0: continue
			_big_candidates.erase(Vector2i(x, y))

func _printMaze_Debug(maze: MazeData):
	if !Debug.MAZE_GENERATION_MSG || !Debug.MAZE_GENERATION_TRACE: return
	var buffer: Array[String]
	print("")
	print("--- ", "MAP NAME", " ---")
	for y in range(map_height):
		buffer = ["", "", ""]
		for x in range(map_width):
			var cell = maze.get_cell(Vector2i(x, y))
			if cell.big:
				if cell.north: buffer[0] += "X X"
				else: buffer[0] += "XXX"
				if cell.west: buffer[1] += "  "
				else: buffer[1] += "X "
				if cell.east: buffer [1] += " "
				else: buffer[1] += "X"
				if cell.south: buffer[2] += "X X"
				else: buffer[2] += "XXX"
			else:
				if cell.north: buffer[0] += "#.#"
				else: buffer[0] += "###"
				if cell.west: buffer[1] += ".."
				else: buffer[1] += "#."
				if cell.east: buffer [1] += "."
				else: buffer[1] += "#"
				if cell.south: buffer[2] += "#.#"
				else: buffer[2] += "###"
		print(buffer[0])
		print(buffer[1])
		print(buffer[2])
	print("--- ", "--- ----", " ---")
	print("")

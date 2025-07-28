class_name RoomLoader
extends RefCounted

var rooms: Dictionary[int, Array]

func _init() -> void:
	_load_room_files()

func _load_room_files() -> void:
	var roomdir := DirAccess.open("res://resources/rooms")
	if roomdir == null:
		printerr("Could not read rooms dir: ", DirAccess.get_open_error())
	roomdir.list_dir_begin()
	var filename = roomdir.get_next()
	while filename != "":
		if roomdir.current_is_dir(): printerr("Found directory in rooms directory! ", filename)
		elif filename.ends_with(".rooms.txt"):
			_load_rooms(filename)
		elif !filename.ends_with(".png") && !filename.ends_with(".png.import"):
			printerr("Found non room file in rooms directory! ", filename)
		filename = roomdir.get_next()

func _load_rooms(filename) -> void:
	if Debug.ROOM_LOADER: print("found ", filename)
	var file := FileAccess.open("res://resources/rooms/"+filename, FileAccess.READ)
	var line := file.get_csv_line()
	while line.size() > 1:
		var _room: Room
		if int(line[3]) < 16:
			_load_small_rooms(line[4], int(line[3]))
		else:
			_room = _load_room(line)
		line = file.get_csv_line()

func _load_small_rooms(filename: String, type: int):
	_load_small_room(filename, type+0, 0)
	_load_small_room(filename, type+1, 1)
	if type != Room.PIPE:
		_load_small_room(filename, type+2, 2)
		_load_small_room(filename, type+3, 3)
		if Debug.ROOM_LOADER: print("RoomLoader: ", filename, " loaded 4 rooms")
	else:
		if Debug.ROOM_LOADER: print("RoomLoader: ", filename, " loaded 2 rooms")

func _load_small_room(filename: String, type: int, rotation: int) -> Room:
	var image := Image.load_from_file("res://resources/rooms/" + filename)
	if image == null:
		printerr("cant load file ", filename)
		return null
	for r in range(rotation): image.rotate_90(CLOCKWISE)
	var room := Room.new(image)
	var all_rooms_of_type: Array[Room]
	var key := type
	if (rooms.has(key)):
		all_rooms_of_type = rooms.get(key)
		all_rooms_of_type.append(room)
	else:
		all_rooms_of_type.append(room)
		rooms[key] = all_rooms_of_type
	return room

func _load_room(line: PackedStringArray) -> Room:
	var image := Image.load_from_file("res://resources/rooms/" + line[4])
	if image == null : printerr("cant load file ", line[4], " from string ", line)
	var room := Room.new(image)
	
	var all_rooms_of_type: Array[Room]
	var key := int(line[3])
	if (rooms.has(key)):
		all_rooms_of_type = rooms.get(key)
		all_rooms_of_type.append(room)
	else:
		all_rooms_of_type.append(room)
		rooms[key] = all_rooms_of_type
	return room

func getRoom(cell: Cell) -> Room:
	if !rooms.has(cell.room_type): return null
	var myrooms: Array[Room] = rooms.get(cell.room_type)
	if myrooms.is_empty(): return null
	
	return myrooms[0]

func getRooms(cell: Cell) -> Array[Room]:
	if !rooms.has(cell.room_type): return []
	var myrooms: Array[Room] = rooms.get(cell.room_type)
	return myrooms

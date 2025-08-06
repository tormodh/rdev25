class_name Cell
extends Node

static var cell_width: int = 7
static var cell_height: int = 7


var north: bool
var east: bool
var south: bool
var west: bool

var position: Vector2i
var seen: bool
var done: bool
var big: bool

var num_doors: int
var room_type: int

func _init(cellPosition: Vector2i):
	position = cellPosition;
	room_type = Room.NOT_INIT

func open_wall(dir: int) -> void:
	if dir == 0 && !north:
		north = true
		num_doors = num_doors + 1
	elif dir == 1 && !east:
		east = true
		num_doors = num_doors + 1
	elif dir == 2 && !south:
		south = true
		num_doors = num_doors + 1
	elif dir == 3 && !west:
		west = true
		num_doors = num_doors + 1
	else:
		printerr("Trying to open an open wall; cell ", position)

func calculate_dir() -> void:
	if num_doors == 1:
		if room_type == Room.NOT_INIT: room_type = Room.ONE
		if east: room_type += 1
		if south: room_type += 2
		if west: room_type += 3
	if num_doors == 2:
		if north && south:
			if room_type == Room.NOT_INIT: room_type = Room.PIPE
		elif west && east:
			if room_type == Room.NOT_INIT: room_type = Room.PIPE + 1
		else:
			if room_type == Room.NOT_INIT: room_type = Room.CORNER
			if north:
				if west: room_type += 3
			elif east:
				room_type += 1
			else:
				room_type += 2
	if num_doors == 3:
		if room_type == Room.NOT_INIT: room_type = Room.TEE
		if !north:
			room_type += 1
		elif !east:
			room_type += 2
		elif !south:
			room_type += 3
		else:
			room_type += 0
	if num_doors == 4:
		if room_type == Room.NOT_INIT: room_type = Room.CROSS

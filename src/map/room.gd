class_name Room
extends Resource

var image: Image
var dir : int

const NOT_INIT = 0
const UP = 1
const DOWN = 2
const ONE = 3
const PIPE = 4
const CORNER = 5
const TEE = 6
const CROSS = 7

func _init(in_image: Image):
	image = in_image
	dir = 0

func line_up(cell: Cell) -> void:
	if cell.door_dir == dir: return
	while cell.door_dir > dir:
		_rotate_right()
	while cell.door_dir < dir:
		_rotate_left()

func _rotate_right() -> void:
	dir = (dir + 1)%4
	image.rotate_90(CLOCKWISE)

func _rotate_left() -> void:
	dir = (dir + 3)%4
	image.rotate_90(COUNTERCLOCKWISE)

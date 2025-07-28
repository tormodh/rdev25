class_name Room
extends Resource

var image: Image
var dir : int

const NOT_INIT = 15
const ONE = 0
const CORNER = 4
const PIPE = 8
const TEE = 10
const CROSS = 14

func _init(in_image: Image):
	image = in_image
	dir = 0

func _rotate_right() -> void:
	dir = (dir + 1)%4
	image.rotate_90(CLOCKWISE)

func _rotate_left() -> void:
	dir = (dir + 3)%4
	image.rotate_90(COUNTERCLOCKWISE)

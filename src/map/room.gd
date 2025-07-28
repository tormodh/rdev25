class_name Room
extends Resource

var image: Image

const NOT_INIT = 15
const ONE = 0
const CORNER = 4
const PIPE = 8
const TEE = 10
const CROSS = 14

func _init(in_image: Image):
	image = in_image

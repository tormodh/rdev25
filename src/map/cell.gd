class_name Cell
extends Node

@export var north: bool
@export var east: bool
@export var south: bool
@export var west: bool
var position: Vector2i
var seen: bool

func _init(cellPosition: Vector2i):
	north = false
	east = false
	south = false
	west = false
	position = cellPosition;

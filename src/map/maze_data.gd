class_name MazeData
extends RefCounted

var width: int
var height: int
var cells: Array[Cell]

func _init(maze_width: int, maze_height: int) -> void:
	width = maze_width
	height = maze_height
	_setup_cells()

func _setup_cells() -> void:
	cells = []
	for y in height:
		for x in width:
			cells.append(Cell.new())

func get_cell(maze_position: Vector2i) -> Cell:
	var cell_index: int = grid_to_index(maze_position)
	if cell_index == -1:
		return null
	return cells[cell_index]

func grid_to_index(maze_position: Vector2i) -> int:
	if not is_in_bounds(maze_position):
		return -1
	return maze_position.y * width + maze_position.x

func is_in_bounds(coordinate: Vector2i) -> bool:
	return (
		0 <= coordinate.x
		and coordinate.x < width
		and 0 <= coordinate.y
		and coordinate.y < height
	)

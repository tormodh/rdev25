class_name Tile
extends Sprite2D

var _definition: TileDefinition


func _init(gridPos: Vector2i, tileDef: TileDefinition) -> void:
	centered = false
	position = Grid.grid_to_world(gridPos)
	set_tile_type(tileDef)


func set_tile_type(tileDef: TileDefinition) -> void:
	_definition = tileDef
	texture = _definition.texture
	modulate = _definition.color_dark


func is_walkable() -> bool:
	return _definition.is_walkable


func is_transparent() -> bool:
	return _definition.is_transparent

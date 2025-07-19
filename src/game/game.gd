extends Node2D

const player_def: EntityDefinition = preload("res://resources/definitions/entities/actors/entity_def_player.tres")

@onready var player: Entity
@onready var eventHandler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities


func _ready() -> void:
	var playerStartPos: Vector2i = Grid.world_to_grid(get_viewport_rect().size.floor() / 2)
	player = Entity.new(playerStartPos, player_def)
	entities.add_child(player)
	var npc := Entity.new(playerStartPos + Vector2i.RIGHT, player_def)
	npc.modulate = Color.ORANGE_RED
	entities.add_child(npc)

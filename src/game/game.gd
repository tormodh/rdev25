class_name Game
extends Node2D

const player_def: EntityDefinition = preload("res://resources/definitions/entities/actors/entity_def_player.tres")

@onready var player: Entity
@onready var eventHandler: EventHandler = $EventHandler
@onready var entities: Node2D = $Entities
@onready var map: Map = $Map

func _ready() -> void:
	var hardcodeToFirstCell := Vector2i.ZERO
	#var hardcodeToRandomize := Vector2i.MIN
	player = Entity.new(hardcodeToFirstCell, player_def)
	var camera: Camera2D = $Camera2D
	remove_child(camera)
	player.add_child(camera)
	entities.add_child(player)
	map.generate(player)


func _physics_process(_delta: float) -> void:
	var action: Action = eventHandler.get_action()
	if action:
		action.perform(self, player)

func get_map_data() -> MapData:
	return map.map_data

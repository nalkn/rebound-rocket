extends Node2D

const LEVELS: Array[PackedScene] = [
	preload("res://nodes/levels/level_1.tscn")
]

@onready var level_container: Node2D = $LevelContainer
@onready var player: CharacterBody2D = $MyPlayer

var current_index: int = 0
var current_level: BaseLevel = null

func _ready() -> void:
	load_level(0)

func load_level(index: int) -> void:
	if current_level:
		current_level.queue_free()
	
	current_level = LEVELS[index].instantiate() as BaseLevel
	level_container.add_child(current_level)
	
	player.global_position = current_level.get_spawn_position()
	player.velocity = Vector2.ZERO
	
	current_level.level_completed.connect(_on_level_completed)

func _on_level_completed() -> void:
	current_index += 1
	if current_index < LEVELS.size():
		call_deferred("load_level", current_index)
	else:
		print("Jeu terminé !")

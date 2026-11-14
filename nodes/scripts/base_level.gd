class_name BaseLevel
extends Node2D

signal level_completed

@onready var spawn_point: Marker2D = $Spawn
@onready var exit_zone: Area2D = $Exit

func _ready() -> void:
	exit_zone.body_entered.connect(_on_exit_zone_body_entered)

func get_spawn_position() -> Vector2:
	return spawn_point.global_position

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.name == "MyPlayer":
		level_completed.emit()

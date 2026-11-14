class_name BaseLevel
extends Node2D

signal level_completed

@onready var spawn_point: Marker2D = $Spawn
@onready var exit_zone: Area2D = $Exit
@onready var level_logic: Node2D = $levelLogic

var _buttons: Array[PuzzleButton] = []
var exit_unlocked: bool = true

func _ready() -> void:
	exit_zone.body_entered.connect(_on_exit_zone_body_entered)
	for child in level_logic.get_children():
		if child is PuzzleButton:
			_buttons.append(child)
			child.toggled.connect(_on_button_toggled)
	_update_exit_state()

func get_spawn_position() -> Vector2:
	return spawn_point.global_position

func _on_button_toggled(_active: bool) -> void:
	_update_exit_state()

func _update_exit_state() -> void:
	exit_unlocked = _buttons.all(func(b: PuzzleButton) -> bool: return b.is_active)

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.name == "MyPlayer" and exit_unlocked:
		level_completed.emit()

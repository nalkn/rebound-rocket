class_name BaseLevel
extends Node2D

signal level_completed

const EXIT_ACTIVE_TEX := preload("res://assets/sprite-exit-active.png")
const EXIT_LOCKED_TEX := preload("res://assets/sprite-exit-locked.png")
const SFX_PORTAL := preload("res://assets/audio/portal.wav")

@onready var spawn_point: Marker2D = $Spawn
@onready var exit_zone: Area2D = $Exit
@onready var level_logic: Node2D = $levelLogic

var _buttons: Array[PuzzleButton] = []
var exit_unlocked: bool = true

func _ready() -> void:
	exit_zone.collision_layer = 0
	exit_zone.collision_mask = 2
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
	var exit_sprite := exit_zone.get_node_or_null("Sprite2D") as Sprite2D
	if not exit_sprite:
		exit_sprite = Sprite2D.new()
		exit_sprite.name = "Sprite2D"
		exit_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		exit_zone.add_child(exit_sprite)
	exit_sprite.texture = EXIT_ACTIVE_TEX if exit_unlocked else EXIT_LOCKED_TEX

func _on_exit_zone_body_entered(body: Node2D) -> void:
	if body.name == "MyPlayer" and exit_unlocked:
		var sfx := AudioStreamPlayer.new()
		sfx.stream = SFX_PORTAL
		sfx.finished.connect(sfx.queue_free)
		get_tree().current_scene.add_child(sfx)
		sfx.play()
		level_completed.emit()

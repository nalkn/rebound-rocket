class_name PuzzleButton
extends Area2D

signal toggled(active: bool)

const REGION_ACTIVE := Rect2(0, 0, 16, 16)
const REGION_INACTIVE := Rect2(16, 0, 16, 16)
const SFX_BUTTON := preload("res://assets/audio/button.wav")

@export var is_active: bool = false
@export var reset_delay: float = 0.0
@export var min_bounces: int = 0

@onready var sprite: Sprite2D = $Sprite2D

var _reset_timer: SceneTreeTimer = null


func _ready() -> void:
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_body_entered)
	_update_visual()


func _on_body_entered(body: Node2D) -> void:
	if body is Projectile and body.bounces >= min_bounces:
		is_active = not is_active
		_update_visual()
		var sfx := AudioStreamPlayer.new()
		sfx.stream = SFX_BUTTON
		sfx.finished.connect(sfx.queue_free)
		add_child(sfx)
		sfx.play()
		toggled.emit(is_active)
		if is_active and reset_delay > 0.0:
			var timer := get_tree().create_timer(reset_delay)
			_reset_timer = timer
			timer.timeout.connect(func() -> void:
				if _reset_timer == timer and is_active:
					is_active = false
					_update_visual()
					toggled.emit(false)
			)


func _update_visual() -> void:
	if sprite:
		sprite.region_rect = REGION_ACTIVE if is_active else REGION_INACTIVE

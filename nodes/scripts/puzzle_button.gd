class_name PuzzleButton
extends Area2D

signal toggled(active: bool)

const SFX_BUTTON := preload("res://assets/audio/button.wav")

@export var is_active: bool = false
@export var link_color: LaserGate.LinkColor = LaserGate.LinkColor.RED:
	set(value):
		link_color = value
		_update_visual()

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	collision_layer = 0
	collision_mask = 4
	body_entered.connect(_on_body_entered)
	_update_visual()


func _on_body_entered(body: Node2D) -> void:
	if body is Projectile:
		is_active = not is_active
		_update_visual()
		BaseLevel.play_sfx(self, SFX_BUTTON)
		toggled.emit(is_active)


func _update_visual() -> void:
	if sprite:
		var y_off := 80 if is_active else 96
		sprite.region_rect = Rect2(int(link_color) * 16, y_off, 16, 16)

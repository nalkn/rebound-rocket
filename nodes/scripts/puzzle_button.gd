class_name PuzzleButton
extends Area2D

signal toggled(active: bool)

const REGION_ACTIVE := Rect2(0, 0, 16, 16)
const REGION_INACTIVE := Rect2(16, 0, 16, 16)

@export var is_active: bool = false

@onready var sprite: Sprite2D = $Sprite2D


func _ready() -> void:
	body_entered.connect(_on_body_entered)
	_update_visual()


func _on_body_entered(body: Node2D) -> void:
	if body is Projectile:
		is_active = not is_active
		_update_visual()
		toggled.emit(is_active)


func _update_visual() -> void:
	if sprite:
		sprite.region_rect = REGION_ACTIVE if is_active else REGION_INACTIVE

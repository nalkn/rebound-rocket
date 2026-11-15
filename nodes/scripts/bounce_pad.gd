class_name BouncePad
extends Area2D

const IDLE_TEX := preload("res://assets/sprite-jumppad-idle.png")
const ACTIVE_TEX := preload("res://assets/sprite-jumppad-active.png")

@export var jump_boost: float = -420.0

var _sprite: Sprite2D = null


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)

	var rect := get_node_or_null("ColorRect")
	if rect:
		rect.visible = false
	_sprite = get_node_or_null("Sprite2D") as Sprite2D
	if not _sprite:
		_sprite = Sprite2D.new()
		_sprite.name = "Sprite2D"
		_sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		_sprite.position.y = -4.0
		add_child(_sprite)
	_sprite.texture = IDLE_TEX


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "MyPlayer":
		body.velocity.y = jump_boost
		_sprite.texture = ACTIVE_TEX
		get_tree().create_timer(0.2).timeout.connect(func() -> void:
			if is_instance_valid(_sprite):
				_sprite.texture = IDLE_TEX
		)

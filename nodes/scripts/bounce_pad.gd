class_name BouncePad
extends Area2D

@export var jump_boost: float = -420.0


func _ready() -> void:
	collision_layer = 0
	collision_mask = 2
	body_entered.connect(_on_body_entered)


func _on_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D and body.name == "MyPlayer":
		body.velocity.y = jump_boost

class_name Projectile
extends CharacterBody2D

const TEXTURE := preload("res://assets/sprite-projectile-0.png")

var speed := 400.0
var max_bounces := 50
var lifetime := 5.0
var direction := Vector2.RIGHT
var bounces := 0


func _ready() -> void:
	# On construit les enfants en code : plus besoin de scène
	var sprite := Sprite2D.new()
	sprite.texture = TEXTURE
	add_child(sprite)

	var circle := CircleShape2D.new()
	circle.radius = TEXTURE.get_width() / 2.0
	var shape := CollisionShape2D.new()
	shape.shape = circle
	add_child(shape)

	velocity = direction * speed
	get_tree().create_timer(lifetime).timeout.connect(queue_free)


func _physics_process(delta: float) -> void:
	var collision := move_and_collide(velocity * delta)
	if collision:
		velocity = velocity.bounce(collision.get_normal())
		bounces += 1
		if bounces > max_bounces:
			queue_free()

class_name Projectile
extends CharacterBody2D

const TEXTURE := preload("res://assets/sprite-projectile-0.png")
const TEXTURE_BOUNCED := preload("res://assets/sprite-projectile-1.png")
const SFX_BOUNCE := preload("res://assets/audio/bounce.wav")

var speed := 240.0
var max_bounces := 50
var lifetime := 5.0
var direction := Vector2.RIGHT
var bounces := 0


func _ready() -> void:
	collision_layer = 4  
	collision_mask = 17  

	var sprite := Sprite2D.new()
	sprite.texture = TEXTURE
	sprite.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	sprite.scale = Vector2(1.5, 1.5)
	z_index = 10
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
		if collision.get_collider() is LaserGate:
			queue_free()
			return
		velocity = velocity.bounce(collision.get_normal())
		BaseLevel.play_sfx(get_parent(), SFX_BOUNCE, -6.0)
		bounces += 1
		var spr := get_child(0) as Sprite2D
		if spr and bounces == 1:
			spr.texture = TEXTURE_BOUNCED
		if bounces > max_bounces:
			queue_free()

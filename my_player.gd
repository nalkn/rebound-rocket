extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -225.0


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventKey and event.pressed and not event.echo and event.keycode == KEY_A:
		shoot()


func shoot() -> void:
	var p := Projectile.new()
	p.direction = (get_global_mouse_position() - global_position).normalized()
	p.add_collision_exception_with(self)
	get_tree().current_scene.add_child(p)
	p.global_position = global_position

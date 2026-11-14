extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -225.0


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	var p := Projectile.new()
	p.direction = (get_global_mouse_position() - global_position).normalized()
	p.add_collision_exception_with(self)
	var level_container := get_parent().get_node_or_null("LevelContainer")
	var target_parent: Node = level_container.get_child(0) if level_container and level_container.get_child_count() > 0 else get_tree().current_scene
	target_parent.add_child(p)
	p.global_position = global_position

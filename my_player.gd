extends CharacterBody2D

const SPEED = 150.0
const JUMP_VELOCITY = -275.0
const SFX_SHOOT := preload("res://assets/audio/shoot.wav")


func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("ui_up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	var direction := Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	if global_position.y > 220.0:
		respawn()
		return
	for i in get_slide_collision_count():
		if get_slide_collision(i).get_collider() is LaserGate:
			respawn()
			break
	queue_redraw()


func _draw() -> void:
	var to_mouse := get_local_mouse_position()
	var dist := to_mouse.length()
	if dist < 4.0:
		return
	var dir := to_mouse / dist
	var max_len := minf(dist, 80.0)
	var d := 12.0
	while d <= max_len:
		var p := (dir * d).round()
		draw_rect(Rect2(p - Vector2(1, 1), Vector2(2, 2)), Color(1.0, 1.0, 1.0, 0.85))
		d += 8.0


func _get_current_level() -> BaseLevel:
	var level_container := get_parent().get_node_or_null("LevelContainer")
	if level_container and level_container.get_child_count() > 0:
		return level_container.get_child(0) as BaseLevel
	return null


func respawn() -> void:
	velocity = Vector2.ZERO
	var level := _get_current_level()
	if level:
		global_position = level.get_spawn_position()


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_accept") or event.is_action_pressed("shoot"):
		shoot()


func shoot() -> void:
	BaseLevel.play_sfx(self, SFX_SHOOT)
	var p := Projectile.new()
	p.direction = (get_global_mouse_position() - global_position).normalized()
	p.add_collision_exception_with(self)
	var level := _get_current_level()
	var target_parent: Node = level if level else get_tree().current_scene
	target_parent.add_child(p)
	p.global_position = global_position

class_name Fireworks
extends Node2D

var _rockets: Array[Dictionary] = []
var _particles: Array[Dictionary] = []


func _ready() -> void:
	z_index = 20
	var colors := [
		Color(1.0, 0.85, 0.2),
		Color(0.25, 0.9, 1.0),
		Color(1.0, 0.35, 0.75),
		Color(0.4, 1.0, 0.45),
		Color(1.0, 0.55, 0.2),
		Color(0.75, 0.45, 1.0),
		Color(1.0, 1.0, 1.0),
	]
	for i in colors.size():
		_rockets.append({
			"pos": Vector2(randf_range(-80.0, 80.0), 20.0),
			"vel": Vector2(randf_range(-18.0, 18.0), randf_range(-165.0, -115.0)),
			"delay": i * 0.22,
			"fuse": randf_range(0.55, 0.8),
			"color": colors[i],
		})


func _process(delta: float) -> void:
	var remaining_rockets: Array[Dictionary] = []
	for r in _rockets:
		if r["delay"] > 0.0:
			r["delay"] -= delta
			remaining_rockets.append(r)
			continue
		r["pos"] += r["vel"] * delta
		r["vel"].y += 40.0 * delta
		r["fuse"] -= delta
		if r["fuse"] <= 0.0:
			_explode(r["pos"], r["color"])
		else:
			remaining_rockets.append(r)
	_rockets = remaining_rockets

	var remaining_particles: Array[Dictionary] = []
	for p in _particles:
		p["pos"] += p["vel"] * delta
		p["vel"].y += 120.0 * delta
		p["vel"] *= 0.98
		p["life"] -= delta
		if p["life"] > 0.0:
			remaining_particles.append(p)
	_particles = remaining_particles

	queue_redraw()
	if _rockets.is_empty() and _particles.is_empty():
		queue_free()


func _explode(origin: Vector2, base_color: Color) -> void:
	for i in 28:
		var angle := (TAU / 28.0) * i + randf_range(-0.1, 0.1)
		var spd := randf_range(40.0, 110.0)
		_particles.append({
			"pos": origin,
			"vel": Vector2.from_angle(angle) * spd,
			"life": randf_range(0.7, 1.2),
			"max_life": 1.2,
			"color": base_color,
		})


func _draw() -> void:
	for r in _rockets:
		if r["delay"] <= 0.0:
			draw_rect(Rect2(r["pos"].round(), Vector2(2, 2)), r["color"])
	for p in _particles:
		var c: Color = p["color"]
		c.a = clampf(p["life"] / p["max_life"], 0.0, 1.0)
		draw_rect(Rect2(p["pos"].round(), Vector2(2, 2)), c)

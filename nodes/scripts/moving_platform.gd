class_name MovingPlatform
extends AnimatableBody2D

@export var move_offset := Vector2(80, 0)
@export var speed: float = 40.0
@export var linked_buttons: Array[PuzzleButton] = []

var _start_pos: Vector2
var _progress: float = 0.0
var _direction: float = 1.0
var _active: bool = true


func _ready() -> void:
	_start_pos = position
	for btn in linked_buttons:
		if btn:
			btn.toggled.connect(_on_button_toggled)
	_update_active()


func _on_button_toggled(_state: bool) -> void:
	_update_active()


func _update_active() -> void:
	if linked_buttons.is_empty():
		_active = true
	else:
		_active = linked_buttons.all(func(b: PuzzleButton) -> bool: return b and b.is_active)


func _physics_process(delta: float) -> void:
	if not _active or move_offset == Vector2.ZERO:
		return
	var dist := move_offset.length()
	_progress += (_direction * speed * delta) / dist
	if _progress >= 1.0:
		_progress = 1.0
		_direction = -1.0
	elif _progress <= 0.0:
		_progress = 0.0
		_direction = 1.0
	position = _start_pos.lerp(_start_pos + move_offset, _progress)

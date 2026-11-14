class_name LaserGate
extends StaticBody2D

enum PassMode {
	NONE,        
	BALL_ONLY,   
	PLAYER_ONLY, 
	BOTH,        
}

const LAYER_BLOCKS_PLAYER := 8   
const LAYER_BLOCKS_BALL := 16    

@export var pass_mode: PassMode = PassMode.NONE:
	set(value):
		pass_mode = value
		_apply_mode()

@export var enabled: bool = true:
	set(value):
		enabled = value
		_apply_mode()

@export var linked_buttons: Array[PuzzleButton] = []
@export var invert_buttons: bool = false


func _ready() -> void:
	for btn in linked_buttons:
		if btn:
			btn.toggled.connect(_on_button_toggled)
	_update_from_buttons()


func _on_button_toggled(_active: bool) -> void:
	_update_from_buttons()


func _update_from_buttons() -> void:
	if not linked_buttons.is_empty():
		var all_active := linked_buttons.all(func(b: PuzzleButton) -> bool: return b and b.is_active)
		enabled = all_active if invert_buttons else not all_active
	else:
		_apply_mode()


func _apply_mode() -> void:
	visible = enabled
	if not enabled:
		collision_layer = 0
		return

	match pass_mode:
		PassMode.NONE:
			collision_layer = LAYER_BLOCKS_PLAYER | LAYER_BLOCKS_BALL
			modulate = Color(1.0, 0.25, 0.25, 0.85)
		PassMode.BALL_ONLY:
			collision_layer = LAYER_BLOCKS_PLAYER
			modulate = Color(0.25, 0.75, 1.0, 0.85)
		PassMode.PLAYER_ONLY:
			collision_layer = LAYER_BLOCKS_BALL
			modulate = Color(0.25, 1.0, 0.45, 0.85)
		PassMode.BOTH:
			collision_layer = 0
			modulate = Color(1.0, 1.0, 1.0, 0.35)

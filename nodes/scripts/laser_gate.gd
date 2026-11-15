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
const MYSC_TEX := preload("res://assets/tileset-mysc.png")
const CAP_TOP_REGION := Rect2(32, 0, 16, 4)
const BEAM_REGION := Rect2(32, 4, 16, 8)
const CAP_BOTTOM_REGION := Rect2(32, 12, 16, 4)

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
	var rect := get_node_or_null("ColorRect")
	if rect:
		rect.visible = false
	if not get_node_or_null("BeamSprite"):
		var beam := Sprite2D.new()
		beam.name = "BeamSprite"
		beam.texture = MYSC_TEX
		beam.region_enabled = true
		beam.region_rect = BEAM_REGION
		beam.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		beam.scale = Vector2(1.0, 7.0)
		add_child(beam)

		var top_cap := Sprite2D.new()
		top_cap.name = "TopCap"
		top_cap.texture = MYSC_TEX
		top_cap.region_enabled = true
		top_cap.region_rect = CAP_TOP_REGION
		top_cap.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		top_cap.position = Vector2(0, -30)
		add_child(top_cap)

		var bot_cap := Sprite2D.new()
		bot_cap.name = "BottomCap"
		bot_cap.texture = MYSC_TEX
		bot_cap.region_enabled = true
		bot_cap.region_rect = CAP_BOTTOM_REGION
		bot_cap.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
		bot_cap.position = Vector2(0, 30)
		add_child(bot_cap)
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
	var beam := get_node_or_null("BeamSprite") as Sprite2D
	if not enabled:
		collision_layer = 0
		if beam:
			beam.visible = false
		return

	if beam:
		beam.visible = true
	var beam_color := Color.WHITE
	match pass_mode:
		PassMode.NONE:
			collision_layer = LAYER_BLOCKS_PLAYER | LAYER_BLOCKS_BALL
			beam_color = Color(1.0, 0.25, 0.25, 0.9)
		PassMode.BALL_ONLY:
			collision_layer = LAYER_BLOCKS_PLAYER
			beam_color = Color(0.25, 0.75, 1.0, 0.9)
		PassMode.PLAYER_ONLY:
			collision_layer = LAYER_BLOCKS_BALL
			beam_color = Color(0.25, 1.0, 0.45, 0.9)
		PassMode.BOTH:
			collision_layer = 0
			beam_color = Color(1.0, 1.0, 1.0, 0.35)
	if beam:
		beam.modulate = beam_color

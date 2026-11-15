class_name LaserGate
extends StaticBody2D

enum PassMode {
	NONE,
	BALL_ONLY,
	PLAYER_ONLY,
	BOTH,
}

enum LinkColor {
	RED,
	GREEN,
	YELLOW,
	PURPLE,
	ORANGE,
}

const LAYER_BLOCKS_PLAYER := 8
const LAYER_BLOCKS_BALL := 16
const MYSC_TEX := preload("res://assets/tileset-mysc.png")

@export var pass_mode: PassMode = PassMode.NONE:
	set(value):
		pass_mode = value
		_apply_mode()

@export var link_color: LinkColor = LinkColor.RED:
	set(value):
		link_color = value
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
		_add_part("BeamSprite", Rect2(32, 4, 16, 8), Vector2.ZERO, Vector2(1.0, 7.0))
		_add_part("TopCap", Rect2(0, 64, 16, 4), Vector2(0, -30))
		_add_part("BottomCap", Rect2(0, 68, 16, 4), Vector2(0, 30))
	for btn in linked_buttons:
		if btn:
			btn.toggled.connect(func(_a: bool) -> void: _update_from_buttons())
	_update_from_buttons()


func _add_part(part_name: String, region: Rect2, pos: Vector2, sc := Vector2.ONE) -> void:
	var spr := Sprite2D.new()
	spr.name = part_name
	spr.texture = MYSC_TEX
	spr.region_enabled = true
	spr.region_rect = region
	spr.texture_filter = CanvasItem.TEXTURE_FILTER_NEAREST
	spr.position = pos
	spr.scale = sc
	add_child(spr)


func _update_from_buttons() -> void:
	if not linked_buttons.is_empty():
		var all_active := linked_buttons.all(func(b: PuzzleButton) -> bool: return b and b.is_active)
		enabled = all_active if invert_buttons else not all_active
	else:
		_apply_mode()


func _apply_mode() -> void:
	var top_cap := get_node_or_null("TopCap") as Sprite2D
	var bot_cap := get_node_or_null("BottomCap") as Sprite2D
	if top_cap:
		top_cap.region_rect = Rect2(int(pass_mode) * 16, 64, 16, 4)
	if bot_cap:
		bot_cap.region_rect = Rect2(int(pass_mode) * 16, 68, 16, 4)

	var beam := get_node_or_null("BeamSprite") as Sprite2D
	if beam:
		beam.region_rect = Rect2(int(link_color) * 16, 112, 16, 8)
		beam.visible = enabled
	if not enabled:
		collision_layer = 0
		return

	match pass_mode:
		PassMode.NONE:
			collision_layer = LAYER_BLOCKS_PLAYER | LAYER_BLOCKS_BALL
		PassMode.BALL_ONLY:
			collision_layer = LAYER_BLOCKS_PLAYER
		PassMode.PLAYER_ONLY:
			collision_layer = LAYER_BLOCKS_BALL
		PassMode.BOTH:
			collision_layer = 0

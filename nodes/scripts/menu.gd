extends Control

@onready var play_button: Button = $CanvasLayer/CenterContainer/VBoxContainer/PlayButton


func _ready() -> void:
	play_button.pressed.connect(_on_play_pressed)
	play_button.grab_focus()


func _on_play_pressed() -> void:
	get_tree().change_scene_to_file("res://nodes/main.tscn")

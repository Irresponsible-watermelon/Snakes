extends Node

var is_options_open: bool = false
var options_menu = preload("res://SceneController/options/options.tscn")
var options: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Game.esc_pressed.connect(on_esc_pressed)

func load_game():
	pass

func on_esc_pressed():
	if is_options_open:
		hide_options()
		
func show_options():
	options = options_menu.instantiate()
	add_child(options)
	
func hide_options():
	if is_instance_valid(options):
		options.queue_free()
		options = null

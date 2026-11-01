extends Node

enum type {
	PAUSE,
	HIDE,
	BOTH
}

var is_options_open: bool = false
var options_menu = preload("res://SceneController/options/options.tscn")
var options: Control
var game_scene = preload("res://SceneController/Game/Snake/snake.tscn")
var game: Node2D
var start_scene = preload("res://SceneController/Start_menu/start_menu.tscn")
var start: Control
var death_scene = preload("res://SceneController/Death_Screen/death_screen.tscn")
var death: Control

@onready var game_temp = Game

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_temp.esc_pressed.connect(on_esc_pressed)

func on_esc_pressed():
	print("Function triggered by signal")
	if is_options_open:
		del_options()

#scene loaders

func show_load_game():
	if (not is_instance_valid(game)) and get_node_or_null("Game") == null:
		game = game_scene.instantiate()
		add_child(game)
	elif is_instance_valid(game):
		game.process_mode = Node.PROCESS_MODE_ALWAYS
		game.show()

func show_load_options():
	if not is_instance_valid(options):
		options = options_menu.instantiate()
		add_child(options)
	elif is_instance_valid(options):
		options.show()
		options.process_mode = Node.PROCESS_MODE_ALWAYS

func show_load_start():
	if not is_instance_valid(start):
		start = start_scene.instantiate()
		add_child(start)
	elif is_instance_valid(start):
		start.process_mode = Node.PROCESS_MODE_ALWAYS
		start.show()

func show_load_death():
	if not is_instance_valid(death):
		death = death_scene.instantiate()
		add_child(death)
	elif is_instance_valid(death):
		death.process_mode = Node.PROCESS_MODE_ALWAYS
		death.show()

#scene pausers & Hiders

func pause_hide_game(kind):
	
	match kind:
		type.PAUSE:
			kind = type.PAUSE
		type.HIDE:
			kind = type.HIDE
		type.BOTH: 
			kind = type.BOTH
	
	if is_instance_valid(game) and not get_node_or_null("Game") == null:
		
		if kind == type.HIDE or kind == type.BOTH:
			game.hide()
		elif kind == type.PAUSE or kind == type.BOTH:
			game.process_mode = Node.PROCESS_MODE_DISABLED

func pause_hide_start():
	if is_instance_valid(start):
		start.hide()
		start.process_mode = Node.PROCESS_MODE_DISABLED

func pause_hide_options():
	if is_instance_valid(options):
		options.hide()
		options.process_mode = Node.PROCESS_MODE_DISABLED
		
func pause_hide_death():
	if is_instance_valid(death):
		death.hide()
		death.process_mode = Node.PROCESS_MODE_DISABLED
#scene deleters

func del_options():
	if is_instance_valid(options):
		options.queue_free()
		options = null

func del_game():
	if is_instance_valid(game):
		game.queue_free()
		game = null
		
func del_start():
	if is_instance_valid(start):
		start.queue_free()
		start = null

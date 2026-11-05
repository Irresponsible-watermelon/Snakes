extends Node

var options_menu = preload("res://SceneController/options/options.tscn")
var options: Control
var game_scene: PackedScene
var game: Node2D
var start_scene = preload("res://SceneController/Start_menu/start_menu.tscn")
var start: Control
var death_scene = preload("res://SceneController/Death_Screen/death_screen.tscn")
var death: Control

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#passes new pause state after esc pressing
	show_load_game()
	game.esc_pressed.connect(on_esc_pressed)



func on_esc_pressed(is_paused: bool):
	if is_paused:
		pause_hide_game(SceneManger.type.BOTH)
	elif not is_paused:
		show_load_game()
		pause_hide_options(SceneManger.type.BOTH)

#scene loaders

func show_load_game():
	print("SHOW LOAD GAME CALLED")

	if not is_instance_valid(game):
		game_scene = load("res://SceneController/Game/Game.tscn")

		if game_scene == null:
			print("ERROR: Game scene failed to load")
			return

		game = game_scene.instantiate()
		add_child(game)

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
		SceneManger.type.PAUSE:
			kind = SceneManger.type.PAUSE
		SceneManger.type.HIDE:
			kind = SceneManger.type.HIDE
		SceneManger.type.BOTH: 
			kind = SceneManger.type.BOTH
	
	if is_instance_valid(game) and not get_node_or_null("Game") == null:
		
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			game.hide()
		elif kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH:
			game.process_mode = Node.PROCESS_MODE_DISABLED

func pause_hide_start(kind):
	match kind:
		SceneManger.type.PAUSE:
			kind = SceneManger.type.PAUSE
		SceneManger.type.HIDE:
			kind = SceneManger.type.HIDE
		SceneManger.type.BOTH: 
			kind = SceneManger.type.BOTH
	
	if is_instance_valid(start):
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			start.hide()
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH:
			start.process_mode = Node.PROCESS_MODE_DISABLED

func pause_hide_options(kind):
	match kind:
		SceneManger.type.PAUSE:
			kind = SceneManger.type.PAUSE
		SceneManger.type.HIDE:
			kind = SceneManger.type.HIDE
		SceneManger.type.BOTH: 
			kind = SceneManger.type.BOTH
			
	if is_instance_valid(options):
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			options.hide()
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH:
			options.process_mode = Node.PROCESS_MODE_DISABLED
		
func pause_hide_death(kind):
	
	match kind:
		SceneManger.type.PAUSE:
			kind = SceneManger.type.PAUSE
		SceneManger.type.HIDE:
			kind = SceneManger.type.HIDE
		SceneManger.type.BOTH: 
			kind = SceneManger.type.BOTH
	
	if is_instance_valid(death):
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			death.hide()
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH:
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

#score handling

func score_on_apple_eaten():
	SceneManger.survival_time = 0
	SceneManger.score += roundi(max((SceneManger.difficulty * 2) + (SceneManger.true_cps * 50) , 100))
	
func survival_score():
	SceneManger.survival_time += 1
	if SceneManger.survival_time <= 5:
		SceneManger.score += roundi(max(SceneManger.difficulty * 2, 1))

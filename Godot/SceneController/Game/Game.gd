extends Node2D

@export var snake: Snake
#Pause_Menu handler
var is_paused: bool = false
signal esc_pressed(is_paused: bool)#
signal options_trigger
var pause_tscn = preload("res://SceneController/Game/pause/pause.tscn")
var pause_node: Control

func _ready():
	print("GAME INSTANCE CREATED")
	print("Instance ID: ", get_instance_id())
	print("Node path: ", get_path())
	pause()
	unpause(SceneManger.type.BOTH)

func _input(event: InputEvent):
	print_debug("is paused", is_paused)
	if event.is_action_pressed("Esc") and not is_paused:
		pause()
		esc_pressed.emit(is_paused)
	elif event.is_action_pressed("Esc") and is_paused:
		unpause(SceneManger.type.BOTH)
		esc_pressed.emit(is_paused)

#pause menu scene handlers

func pause():
	if not is_instance_valid(pause_node):
		pause_node = pause_tscn.instantiate()
		pause_node.process_mode = Node.PROCESS_MODE_WHEN_PAUSED
		add_child(pause_node)
		get_tree().paused = true
		is_paused = true
		button_setup()
	
	elif is_instance_valid(pause_node):
		get_tree().paused = true
		pause_node.show()
		is_paused = true

func unpause(kind):
	print("pause hide pause triggered")
	print("Kind received: ", kind)
	print("Pause valid: ", is_instance_valid(pause_node))
	if is_instance_valid(pause_node):
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH: 
			get_tree().paused = false
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			pause_node.hide()
			is_paused = false
			print_debug("pause hide pause hidden")

func del_pause():
	if is_instance_valid(pause_node):
		get_tree().paused = false
		pause_node.queue_free()
		pause_node = null
		is_paused = false

#button click handlers

func button_setup():
	if is_instance_valid(pause_node):
		pause_node.get_node("SubViewport/Esc/Button").pressed.connect(on_close_button)
		pause_node.get_node("SubViewport/middle buttons/Resume/Resume").pressed.connect(on_resume_button)
		pause_node.get_node("SubViewport/middle buttons/Quit/QuitButton").pressed.connect(on_quit_button)
		pause_node.get_node("SubViewport/middle buttons/MenuButton/MenuButton").pressed.connect(on_menu_button)

func on_close_button():
	unpause(SceneManger.type.BOTH)
	if is_instance_valid(SceneManger.options) and (SceneManger.options.process_mode == Node.PROCESS_MODE_ALWAYS or SceneManger.options.visible == true):
		SceneManger.pause_hide_options(SceneManger.type.BOTH)
		
func on_resume_button():
	unpause(SceneManger.type.BOTH)
func on_quit_button():
	get_tree().quit()
func on_menu_button():
	options_trigger.emit()

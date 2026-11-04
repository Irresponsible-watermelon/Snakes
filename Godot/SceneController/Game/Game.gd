extends Node2D

#Pause_Menu handler
var is_paused: bool
signal esc_pressed(is_paused: bool)
var pause_scene = preload("res://SceneController/Game/pause/pause.tscn")
var pause: Control

func _ready():
	print("starting up")
	load_show_pause()
	pause_hide_pause(SceneManger.type.BOTH)

func _input(event: InputEvent):
	print_debug("is paused", is_paused)
	if event.is_action_pressed("Esc") and not is_paused:
		load_show_pause()
		esc_pressed.emit(is_paused)
	elif event.is_action_pressed("Esc") and is_paused:
		pause_hide_pause(SceneManger.type.BOTH)
		esc_pressed.emit(is_paused)

#pause menu scene handlers

func load_show_pause():
	if not is_instance_valid(pause):
		pause = pause_scene.instantiate()
		add_child(pause)
		is_paused = true
		button_setup()
	
	elif is_instance_valid(pause):
		pause.process_mode = Node.PROCESS_MODE_ALWAYS
		pause.show()
		is_paused = true

func pause_hide_pause(kind):
	print("pause hide pause triggered")
	print("Kind received: ", kind)
	print("Pause valid: ", is_instance_valid(pause))
	if is_instance_valid(pause):
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH: 
			pause.process_mode = Node.PROCESS_MODE_ALWAYS
			is_paused = false
			print_debug("pause hide pause suspended")
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			pause.hide()
			is_paused = false
			print_debug("pause hide pause hidden")

func del_pause():
	if is_instance_valid(pause):
		pause.queue_free()
		pause = null
		is_paused = false

#button click handlers

func button_setup():
	if is_instance_valid(pause):
		pause.get_node("SubViewport/Esc/Button").pressed.connect(on_close_button)
		pause.get_node("SubViewport/middle buttons/Resume/Resume").pressed.connect(load_show_pause)
func on_close_button():
	pause_hide_pause(SceneManger.type.BOTH)
	if is_instance_valid(SceneManger.options) and (SceneManger.options.process_mode == Node.PROCESS_MODE_ALWAYS or SceneManger.options.visible == true):
		SceneManger.pause_hide_options(SceneManger.type.BOTH)

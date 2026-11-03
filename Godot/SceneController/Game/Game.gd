extends Node2D

func score_on_apple_eaten():
	SceneManger.survival_time = 0
	SceneManger.score += roundi(max((SceneManger.difficulty * 2) + (SceneManger.true_cps * 50) , 100))
	
func survival_score():
	SceneManger.survival_time += 1
	if SceneManger.survival_time <= 5:
		SceneManger.score += roundi(max(SceneManger.difficulty * 2, 1))

#Pause_Menu handler
var is_paused: bool
signal esc_pressed(is_paused: bool)
var pause_scene = preload("res://SceneController/Game/pause/pause.tscn")
@export var pause: Control

func _ready():
	print("starting up")
	button_setup()
	pause_hide_pause(SceneManger.type.BOTH)

func _input(event: InputEvent):
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
		is_paused = false
	
	elif is_instance_valid(pause):
		pause.process_mode = Node.PROCESS_MODE_ALWAYS
		pause.show()
		is_paused = false

func pause_hide_pause(kind):
	print("function triggered")
	match kind:
		SceneManger.type.PAUSE:
			kind = SceneManger.type.PAUSE
		SceneManger.type.HIDE:
			kind = SceneManger.type.HIDE
		SceneManger.type.BOTH: 
			kind = SceneManger.type.BOTH
	
	if is_instance_valid(pause):
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH: 
			pause.process_mode = Node.PROCESS_MODE_ALWAYS
			is_paused = true
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			pause.hide()
			is_paused = true

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

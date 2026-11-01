extends Node2D

var cell_size: int = 100
var cells_across: int = 13 # must be odd
var score: int = 0
var survival_time = 0
var difficulty: int
var true_cps: int = 0

func score_on_apple_eaten():
	survival_time = 0
	score += roundi(max((difficulty * 2) + (true_cps * 50) , 100))
	
func survival_score():
	survival_time += 1
	if survival_time <= 5:
		score += roundi(max(difficulty * 2, 1))

#Pause_Menu handler

signal esc_pressed(esc_pressed: bool)
var is_paused: bool
var pause_scene = preload("res://SceneController/Game/pause/pause.tscn")
@export var pause: Control

func _onready():
	button_setup()

func _input(event: InputEvent):
	emit_signal("esc_pressed")
	if event.is_action_pressed("Esc") and not is_paused:
		load_show_pause()
	elif event.is_action_pressed("Esc") and is_paused:
		pause_hide_pause(SceneManger.type.BOTH)

#pause menu scene handlers

func load_show_pause():
	if not is_instance_valid(pause):
		pause = pause_scene.instantiate()
		add_child(pause)
	
	elif is_instance_valid(pause):
		pause.process_mode = Node.PROCESS_MODE_ALWAYS
		pause.show()

func pause_hide_pause(kind):
	
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
		if kind == SceneManger.type.HIDE or kind == SceneManger.type.BOTH:
			pause.hide()

func del_pause():
	if is_instance_valid(pause):
		pause.queue_free()
		pause = null

#button click handlers

func button_setup():
	$PauseMenu/SubViewport/Esc/Button.pressed.connect(on_close_button)
	$"PauseMenu/SubViewport/middle buttons/Resume".pressed.connect(load_show_pause)

func on_close_button():
	pause_hide_pause(SceneManger.type.BOTH)
	if is_instance_valid(SceneManger.options) and (SceneManger.options.process_mode == Node.PROCESS_MODE_ALWAYS or SceneManger.options.visible == true):
		SceneManger.pause_hide_options(SceneManger.type.BOTH)

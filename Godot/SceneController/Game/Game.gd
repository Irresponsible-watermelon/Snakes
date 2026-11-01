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

@export var pause: Control

func _input(event: InputEvent):
	emit_signal("esc_pressed")
	if event.is_action_pressed("Esc") and not is_paused:
		show_pause()
	elif event.is_action_pressed("Esc") and is_paused:
		hide_pause()

func show_pause():
	pause.hide()
	pause.process_mode = Node.PROCESS_MODE_DISABLED
func hide_pause():
	pause.process_mode = Node.PROCESS_MODE_ALWAYS
	pause.show()

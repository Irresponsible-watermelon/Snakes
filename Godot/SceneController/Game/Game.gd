extends Node2D

@export var snake: Snake
@export var bg_col_rect: ColorRect
#Pause_Menu handler
var is_paused: bool
signal esc_pressed(is_paused: bool)
var pause_tscn = preload("res://SceneController/Game/pause/pause.tscn")
var pause_node: Control


func _ready():
	print("GAME INSTANCE CREATED")
	print("Instance ID: ", get_instance_id())
	print("Node path: ", get_path())
	SceneManger.border_update.connect(queue_redraw)
	SceneManger.options_update.connect(on_options_update)
	pause()
	unpause(SceneManger.type.BOTH)
	on_options_update()

func _input(event: InputEvent):
	if event.is_action_pressed("Esc"):
		print_debug("is paused", is_paused)
		if is_paused:
			unpause(SceneManger.type.BOTH)
			esc_pressed.emit(is_paused)
			SceneManger.options_state.emit(false)
		elif not is_paused:
			pause()

func on_options_update():
	bg_col_rect.color = SceneManger.background_col
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
		is_paused = true
		pause_node.show()

func unpause(kind):
	print("pause hide pause triggered")
	print("Kind received: ", kind)
	print("Pause valid: ", is_instance_valid(pause_node))
	if is_instance_valid(pause_node):
		if kind == SceneManger.type.PAUSE or kind == SceneManger.type.BOTH: 
			get_tree().paused = false
			is_paused = false
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
		pause_node.get_node("SubViewport/middle buttons/MenuButton/MenuButton").pressed.connect(on_options_button)

func on_close_button():
	unpause(SceneManger.type.BOTH)
	if SceneManger.is_options:
		SceneManger.options_state.emit(false)

func on_resume_button():
	on_close_button()

func on_quit_button():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

func on_options_button():
	print_debug("options button pressed")
	if SceneManger.is_options == false:
		SceneManger.options_state.emit(true)

func _draw():
	for rect in SceneManger.border_rect_list:
		draw_rect(rect, SceneManger.border_col)

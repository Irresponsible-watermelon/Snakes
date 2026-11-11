extends Control

@export var start_button: Button
@export var options_button: Button
@export var quit_button: Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals_connect()

func signals_connect():
	start_button.button_up.connect(start_button_handler)
	options_button.button_up.connect(options_button_handler)
	quit_button.button_up.connect(quit_button_handler)

func start_button_handler():
	SceneManger.game_start.emit()

func options_button_handler():
	if not SceneManger.is_options:
		SceneManger.options_state.emit(true)

func quit_button_handler():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

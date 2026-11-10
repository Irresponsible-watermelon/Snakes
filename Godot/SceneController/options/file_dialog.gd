extends FileDialog

@export var apple_sprt_btn: Button
@export var snake_sprt_btn: Button
@export var options_nd: Panel

var exe_file = OS.get_executable_path()
var launcher_dir = exe_file.get_base_dir().get_base_dir()
var assets_dir = launcher_dir.path_join("/Assets")
var apples_dir = assets_dir.path_join("/Apple sprites")
var snakes_dir = assets_dir.path_join("/Snake sprites")
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	connect_signals()
	use_native_dialog = true
	show_hidden_files = false
	access = FileDialog.ACCESS_FILESYSTEM


func apple_sprite_select():
	title = "Select an apple sprite"
	file_mode = FileDialog.FILE_MODE_OPEN_FILE
	filters = PackedStringArray(["*.png ; PNG IMAGES"])
	set_current_dir(apples_dir)
	popup_file_dialog()

func snake_sprites_select():
	title = "Select a snake sprite set"
	file_mode = FileDialog.FILE_MODE_OPEN_DIR
	set_current_dir(snakes_dir)
	popup_file_dialog()

func connect_signals():
	apple_sprt_btn.button_up.connect(apple_sprite_select)
	snake_sprt_btn.button_up.connect(snake_sprites_select)

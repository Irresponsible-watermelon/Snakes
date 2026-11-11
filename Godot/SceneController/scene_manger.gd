extends Node

enum type {
	PAUSE,
	HIDE,
	BOTH
}

var is_options_open: bool = false
var is_game_open: bool = true
var is_start_open: bool
var is_death_open: bool
var score: int = 0
var survival_time = 0
var base_cps: float = 1
var true_cps: float = 1
var cps_int: float = 0
var is_start: bool = false
var border_rect_list: Array[Rect2]

var exe_file = OS.get_executable_path()
var launcher_dir = exe_file.get_base_dir().get_base_dir()
var assets_dir = launcher_dir.path_join("/Assets")
var config_dir = assets_dir.path_join("/config.json")

var snake_spr_texs: Array[Resource] = [preload("res://Assets/Snake sprites/My_Snake_1/Body.png"), preload("res://Assets/Snake sprites/My_Snake_1/Up.png"), preload("res://Assets/Snake sprites/My_Snake_1/Down.png"), preload("res://Assets/Snake sprites/My_Snake_1/Left.png"), preload("res://Assets/Snake sprites/My_Snake_1/Right.png")]
var apple_spr_tex: Resource = preload("res://Assets/Apple sprites/Green Apple 50x50 pxlart.png")

var snake_def_texs: Array[Resource] = snake_spr_texs
var apple_def_tex: Resource = apple_spr_tex

var apple_use_tex: Resource = apple_def_tex
var snake_use_texs: Array[Resource] = snake_def_texs

var background_col: Color = Color(0,0,0,1)
var border_col: Color = Color(0.163, 0.108, 0.77, 1.0)

var is_options: bool = false

#variables that need to be saved

var apple_col_tex: Resource
var snake_col_texs: Array[Resource]
var difficulty: int = 3

var cell_size: float = 100
var cells_across: int = 13 # must be odd

var ordered_score_list: Array[int]

var is_ap_spr: bool = true
var is_sn_spr: bool = true


signal options_state(state: bool)
signal options_update
signal settings_push
signal border_update
signal difficulty_update
signal game_start
signal death_open
signal game_end
signal game_restart

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if FileAccess.file_exists(config_dir):
		load_settings()
	get_tree().auto_accept_quit = false
	process_difficulty()
	options_update.connect(on_options_update)

func _notification(what: int) -> void:
	if what == NOTIFICATION_WM_CLOSE_REQUEST:
		save_settings()
		get_tree().quit()

func signal_test():
	settings_push.emit()
	options_state.emit(false)
	options_update.emit()
	border_update.emit()
	game_start.emit()
	death_open.emit()
	game_end.emit()
	game_restart.emit()
#score handling

func score_on_apple_eaten():
	SceneManger.survival_time = 0
	SceneManger.score += roundi(max((SceneManger.difficulty * 2) + (SceneManger.true_cps * 50) , 100))
	
func survival_score():
	SceneManger.survival_time += 1
	if SceneManger.survival_time <= 5:
		SceneManger.score += roundi(max(SceneManger.difficulty * 2, 1))

func process_difficulty():
	if difficulty == 0:
		if is_start:
			base_cps = 1
		cps_int = 0
	elif difficulty == 1:
		if is_start:
			base_cps = 1
		cps_int = 0.01
	elif difficulty == 2:
		if is_start:
			base_cps = 1.5
		cps_int = 0.01
	elif difficulty == 3:
		if is_start:
			base_cps = 1.5
		cps_int = 0.025
	elif difficulty == 4:
		if is_start:
			base_cps = 1.5
		cps_int = 0.4
	elif difficulty == 5:
		if is_start:
			base_cps = 2
		cps_int = 0.05
	elif difficulty == 6:
		if is_start:
			base_cps = 2
		cps_int = 0.075
	elif difficulty == 7:
		if is_start:
			base_cps = 3
		cps_int = 0.075
	elif difficulty == 8:
		if is_start:
			base_cps = 5
		cps_int = 0.1
	elif difficulty == 9:
		if is_start:
			base_cps = 6
		cps_int = 0.1
	elif difficulty == 10:
		if is_start:
			base_cps = 7
		cps_int = 0.2
	difficulty_update.emit()

func on_options_update():
	process_difficulty()
	which_texs()
	
func which_texs():
	if is_ap_spr:
		apple_use_tex = apple_spr_tex
	elif not is_ap_spr and apple_col_tex:
		apple_use_tex = apple_col_tex
	if is_sn_spr:
		snake_use_texs = snake_spr_texs
	elif not is_sn_spr and snake_col_texs:
		snake_use_texs = snake_col_texs
	settings_push.emit()

func does_config_exist():
	var is_config: bool
	return is_config
	
func load_settings():
	var file: FileAccess = FileAccess.open(config_dir, FileAccess.READ)
	
	var apple_col_tex_string: String
	var snake_col_tex_string_0: String
	var snake_col_tex_string_1: String
	
	if file == null:
		push_error("Could not load save file")
		return
	
	var data = JSON.parse_string(file.get_as_text())
	file.close()
	
	if data is Dictionary:
		apple_col_tex_string = data["apple_col_tex_string"]
		snake_col_tex_string_0 = data["snake_col_tex_string_0"]
		snake_col_tex_string_1 = data["snake_col_tex_string_1"]
		difficulty = data["difficulty"]
		cell_size = data["cell_size"]
		cells_across = data["cells_across"]
		ordered_score_list = data["ordered_score_list"]
		is_ap_spr = data["is_ap_spr"]
		is_sn_spr = data["is_sn_spr"]
		
		apple_col_tex = base64_to_tex(apple_col_tex_string)
		snake_col_texs[0] = base64_to_tex(snake_col_tex_string_0)
		snake_col_texs[1] = base64_to_tex(snake_col_tex_string_1)
	else:
		push_error("Save file invalid")

func save_settings():
	var file: FileAccess = FileAccess.open(config_dir, FileAccess.WRITE)
	var apple_col_tex_string: String = tex_to_base64(apple_col_tex)
	var snake_col_tex_string_0: String = tex_to_base64(snake_col_texs[0])
	var snake_col_tex_string_1: String = tex_to_base64(snake_col_texs[1])
	
	var data = {
		"apple_col_tex_string": apple_col_tex_string,
		"snake_col_tex_tex_string_0": snake_col_tex_string_0,
		"snake_col_tex_string_1": snake_col_tex_string_1,
		"difficulty": difficulty,
		"cell_size": cell_size,
		"cells_across": cells_across,
		"ordered_score_list": ordered_score_list,
		"is_ap_spr": is_ap_spr,
		"is_sn_spr": is_sn_spr
	}
	
	file.store_string(JSON.stringify(data))
	file.close()

func tex_to_base64(texture: Texture2D):
	var image: Image = texture.get_image()
	
	var png_bytes: PackedByteArray = image.save_png_to_buffer()
	var encoded_image: String = Marshalls.raw_to_base64(png_bytes)
	
	return encoded_image

func base64_to_tex(base64: String):
	var png_bytes: PackedByteArray = Marshalls.base64_to_raw(base64)
	
	var image = Image.new()
	image.load_png_from_buffer(png_bytes)
	
	if not image == OK:
		push_error("Unable to decode image")
	
	var texture = ImageTexture.create_from_image(image)
	
	return texture

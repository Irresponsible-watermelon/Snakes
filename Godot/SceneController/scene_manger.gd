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
var cell_size: float = 100
var cells_across: int = 13 # must be odd
var score: int = 0
var survival_time = 0
var difficulty: int = 3
var base_cps: float = 1
var true_cps: float = 1
var cps_int: float = 0
var is_start: bool = false
var border_rect_list: Array[Rect2]

var apple_def_tex: Resource
var snake_def_texs: Array[Resource]

var apple_spr_tex: Resource
var snake_spr_texs: Array[Resource]

var apple_col_tex: Resource
var snake_col_texs: Array[Resource]

var apple_use_tex: Resource
var snake_use_texs: Array[Resource]

var background_col: Color = Color(0,0,0,1)
var border_col: Color = Color(0.163, 0.108, 0.77, 1.0)
var is_ap_spr: bool
var is_sn_spr: bool
var is_options: bool = false

signal resource_refresh
signal options_state(state: bool)
signal options_update
signal border_update
signal difficulty_update

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snake_spr_texs = [preload("res://Assets/Snake sprites/My_Snake_1/Body.png"), preload("res://Assets/Snake sprites/My_Snake_1/Up.png"), preload("res://Assets/Snake sprites/My_Snake_1/Down.png"), preload("res://Assets/Snake sprites/My_Snake_1/Left.png"), preload("res://Assets/Snake sprites/My_Snake_1/Right.png")]
	apple_spr_tex = preload("res://Assets/Apple sprites/Green Apple 50x50 pxlart.png")
	snake_def_texs = snake_spr_texs
	apple_def_tex = apple_spr_tex
	snake_use_texs = snake_def_texs
	apple_use_tex = apple_def_tex
	process_difficulty()
	options_update.connect(on_options_update)

func signal_test():
	resource_refresh.emit()
	options_state.emit(false)
	options_update.emit()
	border_update.emit()
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
	elif not is_ap_spr:
		apple_use_tex = apple_col_tex
	if is_sn_spr:
		snake_use_texs = snake_spr_texs
	elif is_sn_spr:
		snake_use_texs = snake_col_texs
	resource_refresh.emit()

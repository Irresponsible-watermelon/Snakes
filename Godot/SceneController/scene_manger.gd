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
var difficulty: int
var true_cps: int = 0
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

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snake_spr_texs = [preload("res://Assets/Snake sprites/My_Snake_1/Body.png"), preload("res://Assets/Snake sprites/My_Snake_1/Up.png"), preload("res://Assets/Snake sprites/My_Snake_1/Down.png"), preload("res://Assets/Snake sprites/My_Snake_1/Left.png"), preload("res://Assets/Snake sprites/My_Snake_1/Right.png")]
	apple_spr_tex = preload("res://Assets/Apple sprites/Green Apple 50x50 pxlart.png")
	snake_def_texs = snake_spr_texs
	apple_def_tex = apple_spr_tex

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

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
var apple_spr_tex: Resource
var snake_spr_texs: Array[Resource]
var background_col: Color
var border_col: Color
var is_ap_spr: bool
var ap_col: Color
var is_sn_spr: bool
var bd_fill_col: Color
var bd_bd_col: Color
var hd_fill_col: Color
var hd_bd_col: Color

signal resource_refresh

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	snake_spr_texs = [preload("res://Assets/Snake sprites/My_Snake_1/Body.png"), preload("res://Assets/Snake sprites/My_Snake_1/Up.png"), preload("res://Assets/Snake sprites/My_Snake_1/Down.png"), preload("res://Assets/Snake sprites/My_Snake_1/Left.png"), preload("res://Assets/Snake sprites/My_Snake_1/Right.png")]
	apple_spr_tex = preload("res://Assets/Apple sprites/Green Apple 50x50 pxlart.png")
#score handling

func score_on_apple_eaten():
	SceneManger.survival_time = 0
	SceneManger.score += roundi(max((SceneManger.difficulty * 2) + (SceneManger.true_cps * 50) , 100))
	
func survival_score():
	SceneManger.survival_time += 1
	if SceneManger.survival_time <= 5:
		SceneManger.score += roundi(max(SceneManger.difficulty * 2, 1))

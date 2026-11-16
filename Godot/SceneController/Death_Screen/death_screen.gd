extends Control

var cur_score: int
var score_list: Array[int]
var is_hs: bool

var death_message_list: Array[String] = [
	#Restart messages
	"Giving up so quickly?",
	"Chiquitita what's wrong?",
	"Here we go again...",
	"Leaving so soon?",
	"I guess things weren't going too well for you",
	#Walls messages
	"It happens sometimes",
	"Watch where you're going!",
	"Don't run off the map!",
	"Was that on purpose?",
	"Try to avoid doing that",
	#Eating self messages
	"How Ouroboric!",
	"Someone got peckish...",
	"Talk about tongue in foot disease...",
	"Mmmmm yummy..?",
	"Did that taste nice?",
]
var death_message_index: int
@export var death_message_nd: Label
@export var hs_pan: Panel
@export var hs_counter_nd: Label
@export var hs_popup_nd: Label
@export var gs_counter_nd: Label
@export var gs_pan: Panel
@export var menu_but_nd: Button
@export var res_but_nd: Button
@export var quit_but_nd: Button
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	signals_connect()
	est_death_message()
	est_score_and_highscore()

func signals_connect():
	menu_but_nd.pressed.connect(on_menu_press)
	res_but_nd.pressed.connect(on_restart_press)
	quit_but_nd.pressed.connect(on_quit_press)

func est_death_message():
	var randint = randi_range(0, 10)
	match SceneManger.cause_of_death:
		
		SceneManger.CauseOfDeath.RESTART:
			match randint:
				0:
					death_message_index = 0
				1, 2, 3:
					death_message_index = 1
				4, 5, 6:
					death_message_index = 2
				7, 8:
					death_message_index = 3
				9, 10:
					death_message_index = 4
		SceneManger.CauseOfDeath.WALL:
			match randint:
				0:
					death_message_index = 5
				1, 2, 3:
					death_message_index = 6
				4, 5, 6:
					death_message_index = 7
				7, 8:
					death_message_index = 8
				9, 10:
					death_message_index = 9
		SceneManger.CauseOfDeath.SELF:
			match randint:
				0:
					death_message_index = 10
				1, 2, 3:
					death_message_index = 11
				4, 5, 6:
					death_message_index = 12
				7, 8:
					death_message_index = 13
				9, 10:
					death_message_index = 14
	
	death_message_nd.text = death_message_list[death_message_index]
	

func est_score_and_highscore():
	cur_score = SceneManger.score
	score_list = SceneManger.ordered_score_list
	var sort_output = sort(score_list, cur_score)
	SceneManger.ordered_score_list = sort_output[0]
	if sort_output[1]:
		hs_popup_nd.show()
	else:
		hs_popup_nd.hide()
	
	hs_counter_nd.text = str("High score: ", SceneManger.ordered_score_list[0])
	hs_counter_nd.position.x += 15
	gs_counter_nd.text = str("Score: ", cur_score)
	gs_counter_nd.position.x += 15
	@warning_ignore("narrowing_conversion")
	hs_pan.size.x = maxi(hs_counter_nd.size.x, gs_counter_nd.size.x) + 30
	gs_pan.size.x = hs_pan.size.x
	
func on_menu_press():
	SceneManger.game_end.emit()

func on_restart_press():
	SceneManger.game_end.emit()
	SceneManger.game_start.emit()

func on_quit_press():
	get_tree().root.propagate_notification(NOTIFICATION_WM_CLOSE_REQUEST)

@warning_ignore("shadowed_variable")
func sort(score_list: Array[int], score_in: int):
	var sorted_list: Array[int] = []
	sorted_list = score_list
	var is_new_hs: bool = false
	var is_equal: bool = false
	for x in range(0, score_list.size()):
		if score_in >= score_list[x]:
			sorted_list.append(score_in)
			if score_in == score_list[x]:
				is_equal = true
		sorted_list.append(score_list[x])
	if cur_score == sorted_list[0] and not is_equal:
		is_new_hs = true
	return [sorted_list, is_new_hs]

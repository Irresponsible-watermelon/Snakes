extends Control

var cur_score: int
var score_list: Array[int]
var is_hs: bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

func signals_connect():
	pass

func est_death_message():
	pass

func est_score_and_highscore():
	cur_score = SceneManger.score
	score_list = SceneManger.ordered_score_list
	var sort_output = sort(score_list, cur_score)
	SceneManger.ordered_score_list = sort_output[0]
	is_hs = sort_output[1]
	
	
	
func is_score_highscore():
	pass

@warning_ignore("shadowed_variable")
func sort(score_list: Array[int], score_in: int):
	var sorted_list: Array[int]
	sorted_list = score_list
	var is_new_hs: bool = false
	var is_equal: bool = false
	for x in range(0, score_list):
		if score_in >= score_list[x]:
			sorted_list.append(score_in)
			if score_in == score_list[x]:
				is_equal = true
		sorted_list.append(score_list[x])
	if cur_score == sorted_list[0] and not is_equal:
		is_new_hs = true
	return [sorted_list, is_new_hs]

extends Node2D

var cell_size: int = 50
var cells_across: int = 12
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

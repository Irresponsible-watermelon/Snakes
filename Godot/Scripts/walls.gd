class_name Walls

extends Node

var walls_dict = {}
var top_left_corner: Vector2
var bottom_right_corner: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var walls = get_tree().get_nodes_in_group("Walls") as Array[Node2D]
	for wall in walls:
		if wall.position.x < 0:
			walls_dict["left"] = wall
		if wall.position.x > 0:
			walls_dict["right"] = wall
		if wall.position.y < 0:
			walls_dict["top"] = wall
		if wall.position.y > 0:
			walls_dict["bottom"] = wall

	print(walls_dict.keys())

	top_left_corner = Vector2((walls_dict["left"].position.x - 50), (walls_dict["top"].position.y) - 50)
	bottom_right_corner = Vector2((walls_dict["right"].position.x), (walls_dict["bottom"].position.y))
# Called every frame. 'delta' is the elapsed time since the previous frame.
@warning_ignore("unused_parameter")
func _process(delta: float) -> void:
	pass

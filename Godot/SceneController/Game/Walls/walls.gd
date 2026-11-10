class_name Walls

extends Node

@export var global: Node
@onready var map_size: float = (SceneManger.cells_across * SceneManger.cell_size) + SceneManger.cell_size
var walls_dict = {}
var top_left_corner: Vector2i
var bottom_right_corner: Vector2i 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	SceneManger.options_update.connect(on_options_update)
	on_options_update()

func on_options_update():
	est_walls()
	est_border_shape()

func est_walls():
	var walls_distance = map_size
	var walls = get_tree().get_nodes_in_group("Walls") as Array[Node2D]
	var scale_needed: float = (float(map_size) / float(600))
	var scale_vec: Vector2 = Vector2(scale_needed,scale_needed)
	for wall in walls:
		if wall.position.x < 0:
			walls_dict["left"] = wall
		if wall.position.x > 0:
			walls_dict["right"] = wall
		if wall.position.y < 0:
			walls_dict["top"] = wall
		if wall.position.y > 0:
			walls_dict["bottom"] = wall
	
	walls_dict["left"].position.x = (0 - (walls_distance / 2))
	walls_dict["left"].scale = scale_vec
	walls_dict["right"].position.x = (0 + (walls_distance / 2))
	walls_dict["right"].scale = scale_vec
	walls_dict["top"].position.y = (0 - (walls_distance / 2))
	walls_dict["top"].scale = scale_vec
	walls_dict["bottom"].position.y = (0 + (walls_distance / 2))
	walls_dict["bottom"].scale = scale_vec

	top_left_corner = Vector2((walls_dict["left"].position.x + SceneManger.cell_size), (walls_dict["top"].position.y) + SceneManger.cell_size)
	bottom_right_corner = Vector2((walls_dict["right"].position.x - SceneManger.cell_size), (walls_dict["bottom"].position.y - SceneManger.cell_size))
	
	for node in walls:
		node.hide()

func est_border_shape():
	var border_rects: Array[Rect2]
	var bdr_size = (SceneManger.cells_across * SceneManger.cell_size) + (SceneManger.cell_size * 2)
	@warning_ignore("narrowing_conversion")
	var top_y_inner: int = top_left_corner.y - (SceneManger.cell_size / 2)
	@warning_ignore("narrowing_conversion")
	var left_x_inner: int = top_left_corner.x - (SceneManger.cell_size / 2)
	@warning_ignore("narrowing_conversion")
	var bottom_y_inner: int = bottom_right_corner.y + (SceneManger.cell_size / 2)
	@warning_ignore("narrowing_conversion")
	var right_x_inner: int = bottom_right_corner.x + (SceneManger.cell_size / 2)
	
	var bottom_rect: Rect2
	bottom_rect.size = Vector2(bdr_size, SceneManger.cell_size)
	bottom_rect.position = Vector2((left_x_inner - SceneManger.cell_size),(bottom_y_inner )) 
	border_rects.append(bottom_rect)
	
	var top_rect: Rect2
	top_rect.size = bottom_rect.size
	top_rect.position = Vector2((left_x_inner - SceneManger.cell_size), top_y_inner - SceneManger.cell_size)
	border_rects.append(top_rect)
	
	var left_rect: Rect2
	left_rect.size = Vector2(SceneManger.cell_size, bdr_size)
	left_rect.position =  top_rect.position
	border_rects.append(left_rect)
	
	var right_rect: Rect2
	right_rect.size = left_rect.size
	right_rect.position = Vector2(right_x_inner, (top_y_inner - SceneManger.cell_size))
	border_rects.append(right_rect)
	
	SceneManger.border_rect_list = border_rects
	SceneManger.border_update.emit()

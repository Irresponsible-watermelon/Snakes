class_name AppleSpawner
extends Node

@export var wall: Walls
@export var food_scene: PackedScene
@export var snake: Snake
@export var global: Main

var apple_position: Vector2
@onready var cell_size = global.cell_size
var apple: Node2D
var food_needed: bool = true
var spawn_count: int = 0


# Called when the node enters the scene tree for the first time.
func _ready():
	if food_needed:
		spawn_food()
		food_needed = false

func spawn_food():
	apple = food_scene.instantiate()
	var pos: Vector2 = generate_food_location()
	while check_food_location(pos):
		pos = generate_food_location()
	add_child(apple)
	apple_position = pos
	apple.position = apple_position
	apple.z_index = -1

func generate_food_location():
	var x_pos = (randi_range( roundi(wall.top_left_corner.x / cell_size), roundi(wall.bottom_right_corner.x / cell_size))) * cell_size
	var y_pos = (randi_range( roundi(wall.top_left_corner.y / cell_size), roundi(wall.bottom_right_corner.y / cell_size))) * cell_size
	return Vector2(x_pos, y_pos)

func check_food_location(pos):
	var is_location_bad = false
	var x_pos = pos.x
	var y_pos = pos.y
	for part in snake.body_parts:
		if (part.position.x == x_pos) and (part.position.y == y_pos):
			is_location_bad = true
			return is_location_bad
	return is_location_bad

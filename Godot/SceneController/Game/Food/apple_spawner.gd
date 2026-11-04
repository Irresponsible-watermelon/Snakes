class_name AppleSpawner
extends Node

@export var wall: Walls
@export var snake: Snake
@export var global: Node

var apple_position: Vector2
var texture = load("res://Assets/Apple sprites/Green Apple 50x50 pxlart.png")
@onready var tex_size: float = texture.get_height()
var scale_needed: float
var apple: Node2D
var food_needed: bool = true
var spawn_count: int = 0
var app_tpl: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	app_tpl = Sprite2D.new()
	app_tpl.hide()
	add_sibling.call_deferred(app_tpl)
	app_tpl.texture = texture
	app_tpl.scale = Vector2(scale_needed, scale_needed)
	
	if food_needed:
		scale_needed = float(SceneManger.cell_size / tex_size)
		spawn_food()

func spawn_food():
	food_needed = false
	apple = app_tpl.duplicate()
	add_sibling.call_deferred(apple)
	var pos: Vector2 = generate_food_location()
	while check_food_location(pos):
		pos = generate_food_location()
	apple_position = pos
	apple.position = apple_position
	apple.z_index = -1
	apple.show()
	print_debug("apple spawned")

func generate_food_location():
	var x_pos = (randi_range( roundi(wall.top_left_corner.x / SceneManger.cell_size), roundi(wall.bottom_right_corner.x / SceneManger.cell_size))) * SceneManger.cell_size
	var y_pos = (randi_range( roundi(wall.top_left_corner.y / SceneManger.cell_size), roundi(wall.bottom_right_corner.y / SceneManger.cell_size))) * SceneManger.cell_size
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

func remove_food():
	if is_instance_valid(apple):
		apple.queue_free()
		apple = null

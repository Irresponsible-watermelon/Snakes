class_name AppleSpawner
extends Node

@export var wall: Walls
@export var snake: Snake
@export var global: Node

var texture: Texture
var apple_position: Vector2
var tex_size: float
var scale_needed: float
var food_needed: bool
var apple: Sprite2D
var spawn_count: int = 0
var app_tpl: Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	print_debug("apple_spawner init")
	
	texture = SceneManger.apple_use_tex
	tex_size = texture.get_height()
	scale_needed = float(SceneManger.cell_size / tex_size)
	SceneManger.settings_push.connect(load_resources)
	
	app_tpl = Sprite2D.new()
	app_tpl.hide()
	add_child(app_tpl)
	app_tpl.texture = texture
	app_tpl.scale = Vector2(scale_needed, scale_needed)
	spawn_food()

func spawn_food():	
	food_needed = false
	apple = app_tpl.duplicate()
	add_child(apple)
	var pos: Vector2 = generate_food_location()
	while check_food_location(pos) == true:
		pos = generate_food_location()
		print_debug("Food location bad")
	apple_position = pos
	apple.position = apple_position
	apple.z_index = 2
	apple.process_mode = Node.PROCESS_MODE_ALWAYS
	apple.show()
	print_debug("apple spawned")

func generate_food_location():
	var x_pos = (randi_range( roundi(wall.top_left_corner.x / SceneManger.cell_size), roundi(wall.bottom_right_corner.x / SceneManger.cell_size))) * SceneManger.cell_size
	var y_pos = (randi_range( roundi(wall.top_left_corner.y / SceneManger.cell_size), roundi(wall.bottom_right_corner.y / SceneManger.cell_size))) * SceneManger.cell_size
	return Vector2(x_pos, y_pos)

func check_food_location(pos):
	var is_location_bad = false
	for part in snake.body_parts:
		if (part.global_position.round() == pos.round()):
			is_location_bad = true
			return is_location_bad
	return is_location_bad

func remove_food():
	if is_instance_valid(apple):
		apple.queue_free()
		apple = null

func load_resources():
	texture = SceneManger.apple_use_tex
	app_tpl.texture = texture
	apple.texture = texture
	tex_size = texture.get_height()
	

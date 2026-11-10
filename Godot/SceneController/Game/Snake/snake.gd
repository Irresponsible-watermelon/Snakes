class_name Snake

extends Node2D

enum CollisionDirection {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
}
# variables soup
var body_parts = []
var head: Sprite2D
var grow_position: Vector2
var apple_eaten = false
var tex_size: int
var scale_needed: int

@onready var snake_parts:Node = $SnakeParts

@onready var body_segment_size = SceneManger.cell_size
@export var walls: Walls
@export var apple_spawner: Node

@onready var apple_needed = apple_spawner.food_needed

var walls_dict

var move_direction = Vector2.UP
var pending_move_direction = Vector2.UP
var wait_time = float(float(1) / SceneManger.true_cps)
var has_collisioned: bool = false
var snake_dead:bool
var timer: Timer

# Called when the node enters the scene tree for the first time.
func _ready():
	
	#setup timer
	SceneManger.difficulty_update.connect(on_wait_update)
	timer = Timer.new()
	add_sibling.call_deferred(timer)
	timer.wait_time = wait_time
	timer.autostart = true
	timer.process_mode =Node.PROCESS_MODE_PAUSABLE
	timer.timeout.connect(on_timeout)
	
	load_resources()
	SceneManger.resource_refresh.connect(load_resources)
	
	scale_needed = int(body_segment_size / tex_size)
	head = Sprite2D.new()
	head.centered = true
	head.scale = Vector2(scale_needed,scale_needed)
	head.position = Vector2((50 * scale_needed),(50 * scale_needed))
	head.texture = SceneManger.snake_use_texs[1]
	snake_parts.add_child(head)
	body_parts.append(head)
	snake_elongate(Vector2((50 * scale_needed),(100 * scale_needed)))
	snake_elongate(Vector2(50 * scale_needed,150 * scale_needed))
	
	walls_dict = walls.walls_dict

func _input(event):
	if (event.is_action_pressed("ui_up") or event.is_action_pressed("Up")) and (move_direction != Vector2.DOWN):
		pending_move_direction = Vector2.UP
	elif (event.is_action_pressed("ui_down") or event.is_action_pressed("Down")) and (move_direction != Vector2.UP):
			pending_move_direction = Vector2.DOWN
	elif (event.is_action_pressed("ui_left") or event.is_action_pressed("Left")) and (move_direction != Vector2.RIGHT):
		pending_move_direction = Vector2.LEFT
	elif (event.is_action_pressed("ui_right") or event.is_action_pressed("Right")) and (move_direction != Vector2.LEFT):
		pending_move_direction = Vector2.RIGHT

#on_game_tick
func on_timeout():
	print_debug("on_timeout triggered")
	#define variables
	move_direction = pending_move_direction
	grow_position = body_parts[-1].position
	
	var new_head_position: Vector2 = new_head_pos_finder()
	var new_bod_position: Array[Vector2] = generate_new_position(new_head_position)
	
	#Check events
	check_wall_collision(new_head_position) 
	is_snake_inself(new_bod_position)
	is_food_eaten(new_head_position)
	
	#direct head
	head_selector(head, move_direction)
	
	#events on survival
	if not has_collisioned:
		move_to_position(new_bod_position)
		SceneManger.survival_score()
		print_debug("true_cps: ", SceneManger.true_cps)
	elif has_collisioned:
		snake_dead = true
#functions library

#Thinking functions
func new_head_pos_finder():
	print_debug("new_head_pos_finder triggered")
	var new_head_position = body_parts[0].position
	
	if move_direction == Vector2.UP:
		new_head_position.y -= body_segment_size
	elif move_direction == Vector2.DOWN:
		new_head_position.y += body_segment_size
	elif move_direction == Vector2.LEFT:
		new_head_position.x -= body_segment_size
	elif move_direction == Vector2.RIGHT:
		new_head_position.x += body_segment_size
	return new_head_position

func head_selector(fn_head: Sprite2D, fn_move_direction: Vector2):
	print_debug("head_selector triggered")
	if fn_move_direction == Vector2.UP:
		fn_head.texture = SceneManger.snake_use_texs[1]
	elif fn_move_direction == Vector2.DOWN:
		fn_head.texture = SceneManger.snake_use_texs[2]
	elif fn_move_direction == Vector2.LEFT:
		fn_head.texture = SceneManger.snake_use_texs[3]
	elif fn_move_direction ==  Vector2.RIGHT:
		fn_head.texture = SceneManger.snake_use_texs[4]
	head.texture = fn_head.texture

#event handlers
func snake_elongate(fn_grow_position):
	print_debug("snake_elongate triggered")
	var part = Sprite2D.new()
	part.centered = true
	part.scale = Vector2 (scale_needed, scale_needed)
	part.texture = SceneManger.snake_use_texs[0]
	part.position = fn_grow_position
	snake_parts.add_child(part)
	body_parts.append(part)

func on_food_eaten():
	print_debug("on_food_eaten triggered")
	apple_eaten = true
	apple_needed = false
	SceneManger.score_on_apple_eaten()
	apple_spawner.remove_food()
	apple_spawner.spawn_food()
	
	SceneManger.true_cps += SceneManger.cps_int
	on_wait_update()

func generate_new_position(new_head_position: Vector2):
	var previous_positions: Array[Vector2] = []
	var new_positions: Array[Vector2] = []
	new_positions.append(new_head_position)
	for part in body_parts:
		previous_positions.append(part.position)
	for x in range(1, body_parts.size()):
		new_positions.append(previous_positions[x - 1])
	return new_positions

func move_to_position(new_positions: Array[Vector2]):
	
	for x in range(0, new_positions.size()):
		body_parts[x].position = new_positions[x]
	if apple_eaten:
		snake_elongate(grow_position)
		apple_eaten = false

func load_resources():
	tex_size = SceneManger.snake_use_texs[0].get_height()
	#Bod, UDLR
	for x in range(1, body_parts.size()):
		body_parts[x].texture = SceneManger.snake_use_texs[0]
#collision detectors
func is_snake_inself(new_bod_position: Array[Vector2]):
	print_debug("is_snake_inself triggered")
	var is_inself = false
	for x in range(1, new_bod_position.size()):
		if new_bod_position[x] == new_bod_position[0]:
			is_inself = true
			has_collisioned = true
			return is_inself
	return is_inself

func check_wall_collision(new_head_position: Vector2):
	print_debug("check_wall_collision triggered")
	if (new_head_position.x == walls_dict["left"].position.x) and move_direction == Vector2.LEFT:
		has_collisioned = true
		return true
	elif (new_head_position.y == walls_dict["top"].position.y) and move_direction == Vector2.UP:
		has_collisioned = true
		return true
	elif new_head_position.y == walls_dict["bottom"].position.y and move_direction == Vector2.DOWN:
		has_collisioned = true
		return true
	elif new_head_position.x == walls_dict["right"].position.x and move_direction == Vector2.RIGHT:
		has_collisioned = true
		return true
	else:
		return false

func is_food_eaten(new_head_position: Vector2) -> bool:
	print_debug("is_food_eaten triggered")
	if apple_spawner.apple_position == new_head_position and not apple_needed:
		apple_needed = true
		on_food_eaten()
		return true
	else:
		return false

func on_wait_update():
	wait_time = float(float(1) / SceneManger.true_cps)
	timer.wait_time = wait_time

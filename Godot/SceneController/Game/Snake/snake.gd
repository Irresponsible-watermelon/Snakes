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
var body_texture = preload("res://Assets/Snake sprites/My_Snake_1/Body.png")
var head_up_texture = preload("res://Assets/Snake sprites/My_Snake_1/Up.png")
var head_down_texture = preload("res://Assets/Snake sprites/My_Snake_1/Down.png")
var head_left_texture = preload("res://Assets/Snake sprites/My_Snake_1/Left.png")
var head_right_texture = preload("res://Assets/Snake sprites/My_Snake_1/Right.png")
var head: Sprite2D
var grow_position: Vector2
var apple_eaten = false
var tex_size = body_texture.get_height()
var scale_needed: int

@onready var snake_parts:Node = $SnakeParts
@onready var timer = $Timer

@export var global: Game
@onready var body_segment_size = global.cell_size
@export var walls: Walls
@export var apple_spawner: AppleSpawner
@onready var apple_needed = apple_spawner.food_needed
var walls_dict

var move_direction = Vector2.UP
var pending_move_direction = Vector2.UP
var cells_per_second = 1
var wait_time = (1 / cells_per_second)
var has_collisioned: bool = false
var snake_dead:bool

# Called when the node enters the scene tree for the first time.
func _ready():
	scale_needed = int(body_segment_size / tex_size)
	head = Sprite2D.new()
	head.centered = true
	head.scale = Vector2(scale_needed,scale_needed)
	head.position = Vector2((50 * scale_needed),(50 * scale_needed))
	head.texture = head_up_texture
	snake_parts.add_child(head)
	body_parts.append(head)
	snake_elongate(Vector2((50 * scale_needed),(100 * scale_needed)))
	snake_elongate(Vector2(50 * scale_needed,150 * scale_needed))
	timer.timeout.connect(on_timeout)
	timer.wait_time = wait_time
	
	walls_dict = walls.walls_dict
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

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
	#define variables
	move_direction = pending_move_direction
	grow_position = body_parts[-1].position
	
	var new_head_position = new_head_pos_finder()
	
	#Check events
	check_wall_collision(new_head_position) 
	is_snake_inself(new_head_position)
	if is_food_eaten(new_head_position):
		on_food_eaten()
	
	#direct head
	head_selector(head, move_direction)
	
	#events on survival
	if not has_collisioned:
		move_to_position(new_head_position)
		global.survival_score()
	elif has_collisioned:
		snake_dead = true
#functions library

#Thinking functions
func new_head_pos_finder():
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

func head_selector(head: Sprite2D, move_direction: Vector2):
	if move_direction == Vector2.UP:
		head.texture = head_up_texture
	elif move_direction == Vector2.DOWN:
		head.texture = head_down_texture
	elif move_direction == Vector2.LEFT:
		head.texture = head_left_texture
	elif move_direction ==  Vector2.RIGHT:
		head.texture = head_right_texture

#event handlers
func snake_elongate(grow_position):
	var part = Sprite2D.new()
	part.centered = true
	part.scale = Vector2 (scale_needed, scale_needed)
	part.texture = body_texture
	part.position = grow_position
	snake_parts.add_child(part)
	body_parts.append(part)
	
func on_food_eaten():
	apple_needed = true
	global.score_on_apple_eaten()
	apple_spawner.remove_food()
	apple_spawner.spawn_food()
	snake_elongate(grow_position)
	
func move_to_position(new_head_position):
	var previous_positions: Array[Vector2] = []
	
	for part in body_parts:
		previous_positions.append(part.position)
	for x in range(1, body_parts.size()):
		body_parts[x].position = previous_positions[x - 1]
	
	body_parts[0].position = new_head_position
	if apple_eaten:
		snake_elongate(grow_position)
		apple_eaten = false

#collision detectors
func is_snake_inself(new_head_position):
	var is_inself = false
	for x in range(1, body_parts.size()):
		if body_parts[x].position == new_head_position:
			is_inself = true
			has_collisioned = true
			return is_inself
	return is_inself
	
func check_wall_collision(new_head_position: Vector2):
	if (new_head_position.x == walls_dict["left"].position.x) and move_direction == Vector2.LEFT:
		has_collisioned = true
		return true
		return CollisionDirection.LEFT
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
	return apple_spawner.apple_position == new_head_position

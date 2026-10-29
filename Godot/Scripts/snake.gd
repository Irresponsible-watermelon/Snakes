class_name Snake

extends Node2D

const body_segment_size = 50

enum CollisionDirection {
	TOP,
	BOTTOM,
	LEFT,
	RIGHT,
}

var body_parts = []
var body_texture = preload("res://Assets/Snake sprites/My_Snake_1/Body.png")
var head_up_texture = preload("res://Assets/Snake sprites/My_Snake_1/Up.png")
var head_down_texture = preload("res://Assets/Snake sprites/My_Snake_1/Down.png")
var head_left_texture = preload("res://Assets/Snake sprites/My_Snake_1/Left.png")
var head_right_texture = preload("res://Assets/Snake sprites/My_Snake_1/Right.png")
var head: Sprite2D

@onready var snake_parts:Node = $SnakeParts
@onready var timer = $Timer

@export var walls: Walls
var walls_dict

var move_direction = Vector2.UP
var cells_per_second = 2
var wait_time = (1 / cells_per_second)

# Called when the node enters the scene tree for the first time.
func _ready():
	head = Sprite2D.new()
	head.centered = true
	head.scale = Vector2(1,1)
	head.position = Vector2(50,50)
	head.texture = head_up_texture
	snake_parts.add_child(head)
	body_parts.append(head)
	timer.timeout.connect(on_timeout)
	timer.wait_time = wait_time
	
	walls_dict = walls.walls_dict
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
func _input(event):
	if (event.is_action_pressed("ui_up") or event.is_action_pressed("Up") and move_direction != Vector2.DOWN):
		move_direction = Vector2.UP
	elif (event.is_action_pressed("ui_down") or event.is_action_pressed("Down") and move_direction != Vector2.UP):
			move_direction = Vector2.DOWN
	elif (event.is_action_pressed("ui_left") or event.is_action_pressed("Left") and move_direction != Vector2.RIGHT):
		move_direction = Vector2.LEFT
	elif (event.is_action_pressed("ui_right") or event.is_action_pressed("Right") and move_direction != Vector2.LEFT):
		move_direction = Vector2.RIGHT
	print_debug(move_direction)

func on_timeout():
	var new_head_position = position + (move_direction * body_segment_size)
	
	var wall_collision = check_wall_collision(new_head_position) 
	if wall_collision == null:
		head_selector(head, move_direction)
		move_to_position(new_head_position)
	else:
		var has_collisioned = true
	
	
func move_to_position(new_position):
	position = new_position
	body_parts[0].position = new_position
	
func check_wall_collision(new_head_position: Vector2):
	if (new_head_position.x == walls_dict["left"].position.x) and move_direction == Vector2.LEFT:
		return CollisionDirection.LEFT
	elif (new_head_position.y == walls_dict["top"].position.y) and move_direction == Vector2.UP:
		return CollisionDirection.TOP
	elif new_head_position.y == walls_dict["bottom"].position.y and move_direction == Vector2.DOWN:
		return CollisionDirection.BOTTOM
	elif new_head_position.x == walls_dict["right"].position.x and move_direction == Vector2.RIGHT:
		return CollisionDirection.RIGHT

func head_selector(head: Sprite2D, move_direction: Vector2):
	if move_direction == Vector2.UP:
		head.texture = head_up_texture
	elif move_direction == Vector2.DOWN:
		head.texture = head_down_texture
	elif move_direction == Vector2.LEFT:
		head.texture = head_left_texture
	elif move_direction ==  Vector2.RIGHT:
		head.texture = head_right_texture

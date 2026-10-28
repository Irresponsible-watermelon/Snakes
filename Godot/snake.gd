class_name Snake

extends Node2D

const body_segment_size = 50

var body_parts = []
var body_texture = preload("res://Assets/Snake sprites/My_Snake_1/Body.png")
var head_texture = preload("res://Assets/Snake sprites/My_Snake_1/Up.png")
@onready var snake_parts:Node = $SnakeParts
@onready var timer = $Timer
var move_direction = Vector2.UP
var cells_per_second = 2
var wait_time = (1 / cells_per_second)

# Called when the node enters the scene tree for the first time.
func _ready():
	var head = Sprite2D.new()
	head.position = Vector2(50,50)
	head.scale = Vector2(1,1)
	head.texture = head_texture
	snake_parts.add_child(head)
	body_parts.append(head)
	timer.timeout.connect(on_timeout)
	timer.wait_time = wait_time
	
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
	move_to_position(new_head_position)
	
func move_to_position(new_position):
	position = new_position
	body_parts[0].position = new_position
	

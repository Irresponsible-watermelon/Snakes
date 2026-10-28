class_name Snake

extends Node2D

var body_texture = preload("res://Assets/Snake sprites/My_Snake_1/Body.png")
@onready var snake_parts:Node = $SnakeParts


# Called when the node enters the scene tree for the first time.
func _ready():
	var head = Sprite2D.new()
	head.position = Vector2(0,0)
	head.scale = Vector2(1,1)
	head.texture = body_texture
	snake_parts.add_child(head)
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

extends Node

var character_scene = preload("res://сцены/sana.tscn")
var character_node = null

var start_pos = Vector2(-100, 900)
var target_pos = Vector2(500, 900)
var speed = 300
var moving = false

func _ready():
	character_node = character_scene.instantiate()
	add_child(character_node)
	character_node.position = start_pos
	moving = true

func _process(delta):
	if moving and character_node:
		# Плавно движемся к target_pos
		character_node.position = character_node.position.move_toward(target_pos, speed * delta)
		# Останавливаем движение, когда достигли цели
		if character_node.position.distance_to(target_pos) < 1:
			moving = false

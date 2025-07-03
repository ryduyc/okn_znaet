extends Node2D

var character_scene = preload("res://сцены/sana.tscn")
var character_node = null

@onready var background_sprite = $"Node/Photo2025-07-0223-52-20"
@onready var pause_menu = $Control  # Ваш узел меню настроек

func _ready():
	if not character_node:
		character_node = character_scene.instantiate()
		add_child(character_node)
		character_node.position = Vector2(-500, -500)

	background_sprite.z_as_relative = false
	character_node.z_as_relative = false
	pause_menu.z_as_relative = false

	background_sprite.z_index = 0
	character_node.z_index = 5
	pause_menu.z_index = 10

func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		if pause_menu.visible:
			pause_menu.hide_menu()  # вызываем метод меню
		else:
			pause_menu.show_menu()

extends Node2D

# Общая сцена для всех NPC
var npc_scene = preload("res://сцены/npc.tscn")

# Ссылки на узлы
@onready var background_sprite = $"Photo2025-07-0223-52-20"
@onready var pause_menu = $Control
@onready var dialog_menu = $DialogMenu
@onready var npc_container = $NPCContainer

# Текущий активный NPC
var current_npc = null

func _ready():
	# Начальная настройка интерфейса
	pause_menu.hide()
	dialog_menu.hide()
	
	# Настройка Z-индексов
	_set_z_indices()
	
	# Создаем Sana в начальной позиции
	_spawn_npc("Sana", Vector2(400, 300), "Привет! Я Sana!")

func _set_z_indices():
	# Настройка порядка отрисовки
	background_sprite.z_index = 0
	npc_container.z_index = 5
	pause_menu.z_index = 10
	dialog_menu.z_index = 15
	
	# Отключаем относительные Z-индексы
	background_sprite.z_as_relative = false
	npc_container.z_as_relative = false
	pause_menu.z_as_relative = false
	dialog_menu.z_as_relative = false

func _spawn_npc(npc_name: String, spawn_position: Vector2, dialog: String):
	# Удаляем предыдущего NPC, если есть
	if current_npc:
		current_npc.queue_free()
		current_npc = null
	
	# Создаем нового NPC
	current_npc = npc_scene.instantiate()
	npc_container.add_child(current_npc)
	current_npc.position = spawn_position
	
	# Настраиваем NPC
	current_npc.set_npc_name(npc_name)
	current_npc.set_dialog_text(dialog)
	
	# Для Sana можно добавить особую текстуру
	if npc_name == "Sana":
		var sana_texture = preload("res://asets/piple/sana.png")
		current_npc.set_texture(sana_texture)
	
	# Подключаем сигнал клика
	current_npc.npc_clicked.connect(_on_npc_clicked)
	
	return current_npc

func _unhandled_input(event):
	# Пауза по ESC
	if event.is_action_pressed("pause"):
		if pause_menu.visible:
			pause_menu.hide_menu()
		else:
			pause_menu.show_menu()
	
	# Для отладки: перемещение NPC по пробелу
	if event.is_action_pressed("ui_accept"):
		var new_pos = Vector2(randi_range(100, 700), randi_range(100, 500))
		_spawn_npc("Sana", new_pos, "Я переместилась сюда!")

func _on_npc_clicked():
	# Показываем диалог при клике на NPC
	if current_npc:
		dialog_menu.show_dialog(current_npc.get_npc_name(), current_npc.get_dialog_text())

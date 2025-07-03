extends Area2D

func _ready():
	# Можно настроить позицию, если нужно
	pass 

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed:
		print("Персонаж кликнут!")
		# Здесь можно добавить логику диалога или взаимодействия

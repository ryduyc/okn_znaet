# Прикрепляется к кнопке "Начать"
extends Button

func _pressed():
	# Загружает сцену будки вахтёра
	get_tree().change_scene_to_file("res://сцены/bytka.tscn")

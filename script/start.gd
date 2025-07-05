extends Button

func _pressed():
	# Отладочная информация
	print("Попытка загрузить сцену...")
	
	# Проверяем существование сцены
	var scene_path = "res://сцены/bytka.tscn"
	
	if ResourceLoader.exists(scene_path):
		print("Сцена найдена! Загружаем...")
		# Загружаем сцену будки вахтёра
		get_tree().change_scene_to_file(scene_path)
	else:
		print("ОШИБКА: Сцена не найдена по пути: ", scene_path)
		# Дополнительные проверки
		print("Проверьте:")
		print("- Существование файла ", scene_path)
		print("- Регистр букв в пути")
		print("- Наличие .tscn расширения")
	
	print("Завершение обработки нажатия")

extends Control

# Путь к файлу настроек
const SETTINGS_PATH = "user://settings.cfg"
var config = ConfigFile.new()  # Объект для работы с конфигом

# Элементы интерфейса
@onready var volume_slider = $VBoxContainer/HSlider
@onready var fullscreen_checkbox = $VBoxContainer/CheckBox
@onready var close_button = %CloseButton  # Кнопка закрытия меню

func _ready():
	hide()  # Скрываем меню при запуске
	process_mode = Node.PROCESS_MODE_ALWAYS  # Меню всегда обрабатывает ввод, даже на паузе
	
	# Загружаем сохранённые настройки из файла
	var err = config.load(SETTINGS_PATH)
	if err == OK:
		# Восстанавливаем громкость
		var volume = config.get_value("audio", "volume", 0.0)
		AudioServer.set_bus_volume_db(0, volume)
		if volume_slider:
			volume_slider.value = volume
		
		# Восстанавливаем полноэкранный режим
		var fullscreen = config.get_value("video", "fullscreen", false)
		if fullscreen_checkbox:
			fullscreen_checkbox.button_pressed = fullscreen
			_on_CheckBox_toggled(fullscreen)  # Применяем режим
	
	# Проверяем, что все элементы интерфейса найдены
	if not volume_slider:
		push_error("Не найден слайдер громкости!")
	if not fullscreen_checkbox:
		push_error("Не найден чекбокс полноэкранного режима!")
	if not close_button:
		push_error("Не найдена кнопка закрытия!")
	else:
		# Подключаем обработчик нажатия на кнопку закрытия
		close_button.pressed.connect(_on_CloseButton_pressed)

# Обработка нажатия ESC — закрывает меню, если оно открыто
func _unhandled_input(event):
	if visible and event.is_action_pressed("pause"):
		hide_menu()

# Обработка изменения громкости
func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)  # Устанавливаем громкость
	config.set_value("audio", "volume", value)  # Сохраняем в конфиг
	config.save(SETTINGS_PATH)

# Обработка переключения полноэкранного режима
func _on_CheckBox_toggled(pressed):
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
	config.set_value("video", "fullscreen", pressed)  # Сохраняем в конфиг
	config.save(SETTINGS_PATH)

# Обработка нажатия на кнопку закрытия
func _on_CloseButton_pressed():
	hide_menu()

# Показывает меню с анимацией и ставит игру на паузу
func show_menu():
	modulate = Color(1, 1, 1, 0)  # Начальная прозрачность для анимации
	show()
	process_mode = Node.PROCESS_MODE_ALWAYS  # Меню всегда активно, даже на паузе
	get_tree().paused = true  # Ставим игру на паузу
	
	# Анимация появления меню
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.3)

# Скрывает меню с анимацией и снимает паузу
func hide_menu():
	process_mode = Node.PROCESS_MODE_ALWAYS  # Меню должно быть активно до завершения анимации
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1, 1, 1, 0), 0.3)
	await tween.finished  # Ждём завершения анимации
	
	hide()  # Скрываем меню
	get_tree().paused = false  # Снимаем паузу с игры
	process_mode = Node.PROCESS_MODE_INHERIT  # Возвращаем стандартный режим обработки

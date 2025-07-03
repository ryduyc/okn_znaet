extends Control

@onready var volume_slider = $VBoxContainer/HSlider
@onready var fullscreen_checkbox = $VBoxContainer/CheckBox
@onready var close_button = $Button2  # Кнопка закрытия меню

func _ready():
	hide()
	
	# Устанавливаем Pause Mode, чтобы меню принимало ввод при паузе
	pause_mode = Node.PauseMode.PROCESS
	
	# Инициализация состояния чекбокса полноэкранного режима
	var current_mode = DisplayServer.window_get_mode()
	fullscreen_checkbox.set_pressed(current_mode == DisplayServer.WINDOW_MODE_FULLSCREEN)
	
	# Устанавливаем громкость слайдера
	volume_slider.value = AudioServer.get_bus_volume_db(0)
	
	# Подключаем сигнал кнопки закрытия
	close_button.pressed.connect(_on_CloseButton_pressed)

func _on_HSlider_value_changed(value):
	AudioServer.set_bus_volume_db(0, value)

func _on_CheckBox_toggled(pressed):
	if pressed:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)

func _on_CloseButton_pressed():
	hide_menu()

func show_menu():
	show()
	get_tree().paused = true
	pause_mode = Node.PauseMode.PROCESS  # Обеспечиваем обработку ввода

func hide_menu():
	hide()
	get_tree().paused = false

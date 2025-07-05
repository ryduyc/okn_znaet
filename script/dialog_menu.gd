extends Control

@onready var dialog_label = $Label  # Путь к вашему Label с текстом

func show_dialog(text: String):
	dialog_label.text = text
	show()

func hide_dialog():
	hide()

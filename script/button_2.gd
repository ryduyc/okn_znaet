extends Button
func show_menu():
	show()
	get_tree().paused = true

func hide_menu():
	hide()
	get_tree().paused = false

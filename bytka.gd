extends Node2D

# Загружает шаблон студента
var student_scene = preload("res://asets/sana.png")

func _ready():
	spawn_student()

func spawn_student():
	var new_student = student_scene.instantiate()  # Создаёт экземпляр
	add_child(new_student)  # Добавляет на сцену
	new_student.position = Vector2(500, 300)  # Позиция X=500, Y=300

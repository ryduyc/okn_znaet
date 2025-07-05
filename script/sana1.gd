extends Area2D

# Настройки персонажа
@export var target_pos: Vector2:
	set(value):
		target_pos = value
		if position != target_pos:
			moving = true
			# animation_player.play("walk")  # Раскомментировать при наличии анимации

@export var speed: float = 100.0
@export var dialog_text: String = "Привет! Я Sana!"

# Сигнал при клике на персонажа
signal npc_clicked

# Состояния персонажа
var moving := false
# @onready var animation_player = $AnimationPlayer  # Раскомментировать при наличии анимации
var can_be_clicked: bool = true
var click_tween: Tween

func _ready():
	# Подключаем сигналы
	input_event.connect(_on_input_event)
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	
	# Начальные установки
	scale = Vector2(1.0, 1.0)
	modulate = Color.WHITE

func _process(delta):
	if moving:
		position = position.move_toward(target_pos, speed * delta)
		if position.distance_to(target_pos) < 5.0:
			moving = false
			# animation_player.play("idle")  # Раскомментировать при наличии анимации

func _on_mouse_entered():
	# Эффект при наведении курсора
	scale = Vector2(1.05, 1.05)

func _on_mouse_exited():
	# Возврат к нормальному размеру
	scale = Vector2(1.0, 1.0)

func _on_input_event(viewport: Node, event: InputEvent, shape_idx: int):
	# Проверяем клик левой кнопкой мыши
	if can_be_clicked and event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# Временно блокируем клики
		can_be_clicked = false
		
		# Эффект клика
		_play_click_effect()
		
		# Сигнал о клике
		npc_clicked.emit()
		
		# Восстанавливаем возможность клика через 0.5 секунд
		await get_tree().create_timer(0.5).timeout
		can_be_clicked = true

func _play_click_effect():
	# Отменяем предыдущий твин
	if click_tween and click_tween.is_running():
		click_tween.kill()
	
	# Создаем новый твин для анимации
	click_tween = create_tween()
	
	# Анимация затемнения
	click_tween.tween_property(self, "modulate", Color(0.9, 0.9, 0.9), 0.05)
	
	# Анимация возврата к нормальному цвету
	click_tween.tween_property(self, "modulate", Color.WHITE, 0.15)

func start_moving():
	# Начать движение к цели
	moving = true
	# animation_player.play("walk")  # Раскомментировать при наличии анимации

func get_dialog_text() -> String:
	# Возвращает текст для диалога
	return dialog_text

# Дополнительные функции для взаимодействия
func set_dialog_text(new_text: String):
	# Установить новый текст диалога
	dialog_text = new_text

func teleport_to(position: Vector2):
	# Телепортировать персонажа
	position = position
	target_pos = position
	moving = false

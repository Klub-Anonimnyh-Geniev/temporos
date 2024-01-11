extends Node
var айди_игрок
var пользователь
var меню = preload("res://Сцены/меню.tscn")
@onready var поле_логин: LineEdit = $"вход/VBoxContainer/логин"
@onready var кнопка_входа: Button = $"вход/VBoxContainer/кнопка_вход"
func _ready():
	поле_логин.text_submitted.connect(вход.bind())
	кнопка_входа.pressed.connect(нажатие_кнопки_входа)
	pass
	
func вход(ввод: String):
	if !ввод.is_empty():
		var вход = Data.вход_пользователя(ввод)
		if вход[0]:
			пользователь = вход[1]
			загрузка_меню()
		else:
			print("Ошибка: ", вход[1])
func загрузка_меню():
	print("хуй")
	$"вход".hide()
	var сцена = меню.instantiate()
	сцена.ядро = self
	add_child(сцена)
	pass
func нажатие_кнопки_входа():
	вход(поле_логин.text)
func выход():
	get_tree().quit()

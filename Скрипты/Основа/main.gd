extends Node

var меню = preload("res://Сцены/меню.tscn")
var игра = preload("res://Сцены/проверка.tscn")
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
			NetMenager.мой_логин = вход[2]
			NetMenager.мой_ник = вход[1].get("ник")
			загрузка_меню()
		else:
			print("Ошибка: ", вход[1])
func загрузка_меню():
	$"вход".hide()
	var сцена = меню.instantiate()
	сцена.ядро = self
	add_child(сцена)
	pass
func нажатие_кнопки_входа():
	вход(поле_логин.text)
func выход():
	get_tree().quit()

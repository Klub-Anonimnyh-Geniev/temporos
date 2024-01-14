extends Node
@export_flags("Анемо", "Гео","Электро","Дендро","Гидро") var Элемент = 0
var меню = preload("res://Сцены/меню.tscn")
var игра = preload("res://Сцены/проверка.tscn")
@onready var поле_логин: LineEdit = $"вход/VBoxContainer/логин"
@onready var кнопка_входа: Button = $"вход/VBoxContainer/кнопка_вход"
func _ready():
	поле_логин.text_submitted.connect(вход.bind())
	кнопка_входа.pressed.connect(нажатие_кнопки_входа)
	var A = test.new()
	A.name = "Test"
	var B = test.new()
	A.printA()
	B.a = 13
	B.a = B.a<<1
	B.printA()
	print(bin_string(Элемент))
	pass

func _input(event):
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

class test extends Node:
	@export var a = 1
	
	func printA():
		print(a)
	func _input(event):
		if event.is_action_pressed("ЛКМ"):
			print("AHAHA")
	pass
func bin_string(n):
	var ret_str = ""
	while n > 0:
		ret_str = str(n&1) + ret_str
		n = n>>1
	return ret_str

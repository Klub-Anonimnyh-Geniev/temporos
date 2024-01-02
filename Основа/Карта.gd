@icon("res://Ресурсы/Текстуры/карта.png")
extends Node3D
class_name Карта 

signal меня_разыграли


enum Состояние_карты {нигде, в_руке, в_руке_проотивника, разыгрывается, на_столе}
var состояние: Состояние_карты




var id: StringName
var Название: StringName
var Тип_карты: Категории_карт
var Редкость: StringName
var ЭФФЕКТЫ: Array[Эффекты]
var Стоимость: int
var Возраст: int
var Доп_эффект: Array[Эффекты] = []
var Описание_карты: String
const NameRatio = 2500
var DiscFontSize: int
var NameFontSize: int
var новая_позиция : Vector3
var новый_поворот : Vector3
var изменение_позиции: bool = false
var Кривая_карты_в_руке: Curve
var меня_хотят_разыграть = false
@onready var превью = get_tree().current_scene.find_child("Превьюшка", true, false)
@onready var превьюКарты = get_tree().current_scene.find_child("Превьюха", true, false)
var preview = false
@onready var раб_поз = position
var Таймер_жизнь: Timer
var есть_возрасть: bool = false
func инициализация(ID: StringName = ""):
	id = ID
	Название = Data.дата_карт[ID]["name"]
	print(Название)
	Описание_карты = Data.дата_карт[ID]["описание"]
	Тип_карты = load(Data.дата_карт[ID]["тип"])
	Редкость = Data.дата_карт[ID]["редкость"]
	Стоимость = Data.дата_карт[ID]["стоимость"]
	for e in Data.дата_карт[ID]["эффекты"]:
		ЭФФЕКТЫ.append(load(e))
		
		
	$"Основа_карты/Стоимость".text = str(Стоимость) 
	if Описание_карты != null:
		$"Основа_карты/Описание".text = Описание_карты
		DiscFontSize = Discfunc(Описание_карты.length())
		$"Основа_карты/Описание".font_size = DiscFontSize
		@warning_ignore("integer_division")
		$"Основа_карты/Описание".outline_size = DiscFontSize/3
	$"Основа_карты/Название".text = Название
	NameFontSize = Namefunc(Название.length())
	$"Основа_карты/Название".font_size = NameFontSize
	@warning_ignore("integer_division")
	$"Основа_карты/Название".outline_size = NameFontSize/3
	match Тип_карты.Тип_карты:
		Тип_карты.ТИП_КАРТЫ.СУЩЕСТВО:
			Тип_карты.Атака = Data.дата_карт[ID]["атака"]
			$"Основа_карты/Атака".text = str(Тип_карты.Атака)
			Тип_карты.Здоровье = Data.дата_карт[ID]["здоровье"]
			$"Основа_карты/ХП".text = str(Тип_карты.Здоровье)
			есть_возрасть = true
			Возраст = Data.дата_карт[ID]["время жизни"]
			Таймер_жизнь = $"жизнь"
			Таймер_жизнь.timeout.connect(таймер_смерть)
			$"Основа_карты/Время".text = str(Возраст)
			
			
			
		Тип_карты.ТИП_КАРТЫ.АРТЕФАКТ:
			Тип_карты.Прочность = Data.дата_карт[ID]["прочность"]
			$"Основа_карты/Прочность".text = str(Тип_карты.Прочность)
		Тип_карты.ТИП_КАРТЫ.ЗАКЛИНАНИЕ:
			pass
func Discfunc(x):
	if x <= 170:
		return 75
	else:
		return 65
func Namefunc(x):
	if x <= 15:
		return 150
	else:
		var y = -2.5*x+175
		return y
func положить_карту_в_руку():
	print("aaa")
	if CardManager.КартыВРуке.size() < 10:
		for i in ЭФФЕКТЫ:
			if i.has_method("эффект_при_взятии") == true:
				i.эффект_при_взятии()
		карту_в_руку()
	else:
		сжигание_карты()
func сжигание_карты():
	if CardManager.КартыВРуке.find(self) != -1:
		CardManager.КартыВРуке.remove_at(CardManager.КартыВРуке.find(self))
	queue_free()
func карту_в_руку():
	CardManager.КартыВРуке.append(self)
	CardManager.позиции_в_руке()
	состояние = Состояние_карты.в_руке
	print("aaa")
func _process(_delta):
	if $"Основа_карты".position != раб_поз:
		$"Основа_карты".position = $"Основа_карты".position.lerp(раб_поз, .3)
	if position != новая_позиция:
		position = position.lerp(новая_позиция, .3)
	if rotation != новый_поворот:
		rotation_degrees = rotation_degrees.lerp(новый_поворот, .3)
	match состояние:
		Состояние_карты.разыгрывается:
			Мышь3D()
		Состояние_карты.на_столе:
			pass
func _on_area_3d_mouse_entered():
	match состояние:
			Состояние_карты.в_руке:
				if CardManager.preview:
					раб_поз.z += -1
					вкл_превью()
			Состояние_карты.на_столе:
				if CardManager.preview:
					вкл_превью()
func _on_area_3d_mouse_exited():
	match состояние:
			Состояние_карты.в_руке:
				раб_поз.z += 1
				CardManager.обновление_стола()
				превью.visible = false
			Состояние_карты.на_столе:
				превью.visible = false
func _on_area_3d_input_event(_camera, event, position, _normal, _shape_idx):
	var поз_мышь: Vector2
	var поз_мыши_2: Vector2
	var мышь_расстояние: float
	var режим_мыши = false
	if проверка_маны():
		match состояние:
			Состояние_карты.в_руке:
				if event is InputEventMouseButton:
					if Input.is_action_just_pressed("ЛКМ"):
						поз_мышь = get_tree().current_scene.get_viewport().get_mouse_position()
						меня_хотят_разыграть = true
					if Input.is_action_just_released("ЛКМ"):
						карту_в_мышку()
				if меня_хотят_разыграть:
					if event is InputEventMouseMotion:
						поз_мыши_2 = get_tree().current_scene.get_viewport().get_mouse_position()
						мышь_расстояние = поз_мышь.distance_to(поз_мыши_2)
						if мышь_расстояние > 500:
							карту_в_мышку()
			Состояние_карты.разыгрывается:
				if CardManager.желание_разыграть:
					if Input.is_action_just_pressed("ЛКМ") or Input.is_action_just_released("ЛКМ"):
							розыгрыш_карты()
							Input.action_release("ЛКМ")
				else:
					if Input.is_action_just_pressed("ЛКМ"):
							нерозыгрыш_карты()
							Input.action_release("ЛКМ")
				if Input.is_action_just_pressed("ПКМ"):
					нерозыгрыш_карты()

@warning_ignore("confusable_identifier")
func Мышь3D():
	
	var камера: Camera3D = get_tree().current_scene.find_child("КАМЕРА", true, false)
	var мышь = get_viewport().get_mouse_position()
	print(мышь)
	новая_позиция = камера.project_position(мышь, 15)
	новый_поворот = get_tree().current_scene.find_child("Рука1", true, false).find_child("позРуки", true, false).rotation

func вкл_превью():
	превьюКарты.ресет()
	превьюКарты.создание_карты(id, Название, Описание_карты, Тип_карты, Редкость, ЭФФЕКТЫ, Стоимость, int($"Основа_карты/Прочность".get_text()), int($"Основа_карты/Атака".get_text()), int($"Основа_карты/ХП".get_text()), int($"Основа_карты/Время".get_text()))
	
	превью.position = get_tree().current_scene.find_child("КАМЕРА", true, false).unproject_position(position)
	превью.visible = true
func выкл_превью():
	превью.visible = false
	pass
func розыгрыш_карты():
	if GameManager.Карты1.size() < 7:
		GameManager.манаИгрок1 -= Стоимость
		CardManager.КартыВРуке.remove_at(CardManager.КартыВРуке.find(self))
		CardManager.preview = true
		состояние = Состояние_карты.на_столе
		GameManager.Карты1.append(self)
		GameManager.позицияТокенов()
		CardManager.обновление_стола()
		if есть_возрасть:
			Таймер_жизнь.start()

func нерозыгрыш_карты():
	CardManager.обновление_стола()
	
	состояние = Состояние_карты.в_руке
	меня_хотят_разыграть = false
	CardManager.preview = true

func карту_в_мышку():
	раб_поз = Vector3(0,0,0)
	состояние = Состояние_карты.разыгрывается
	CardManager.preview = false
	CardManager.разыгрывание_карты = true
	CardManager.картуРазыграть = self
	выкл_превью()
	меня_хотят_разыграть = false
func тест_рука_противника():
	CardManager.КартыВРукеПротивника.append(self)
	CardManager.рукаПротивника()
	состояние = Состояние_карты.в_руке_проотивника
	
func проверка_маны(): 
	var моя_мана = GameManager.манаИгрок1
	if Стоимость <= моя_мана:
		return true
	else:
		return false
func таймер_смерть():
	if Возраст > 1:
		Возраст -= 1
		$"Основа_карты/Время".text = str(Возраст)
		if preview == true:
			вкл_превью()
	else:
		превью.visible = false
		GameManager.Карты1.remove_at(GameManager.Карты1.find(self))
		GameManager.позицияТокенов()
		queue_free()
	pass
func test_print():
	новая_позиция = get_tree().current_scene.find_child("позКолода1", true, false).position
	print(get_tree().current_scene.find_child("позКолода1", true, false).position)
	новый_поворот = get_tree().current_scene.find_child("позКолода1", true, false).rotation

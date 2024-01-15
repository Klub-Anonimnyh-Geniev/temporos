@icon("res://Ресурсы/Текстуры и шрифты/карта.png")
extends Node3D
class_name Карта 
## Базовый класс для всех карт.
##
## Класс [Карта] забирает на себя роль самостоятельного игрового юнита,[br]
## Способного быть картой, токеном, оружием, артефактом и т.п
var принадлежность = true
var я = str(self)
## Сигнал разыгрывания.
## В будущем, карта будет посылать этот сигнал в случае своего разыгрывания [b]из руки[/b].
##
## @experimental
signal меня_разыграли(разыгрываемый)
signal меня_разыграл_противник(разыгрываемый)
## Сигнал смерти.
## Отсылается Эффектам для дальнейшего срабатываня
##
## @experimental
signal умер(умерший)

enum Состояние_карты {## Обозначение текущей позиции/роли карты.
	нигде, ## Карта находится в игре, однако не учавствует в игровой механике как таковой.
	в_колоде, ## Карта в коложе
	кладбище, ## Карта на кладбище
	в_руке, ## Карта находится у нас в руке.
	в_руке_проотивника, ## Карта находится в руке нашего противника.
	разыгрывается, ## Непосредственно в данный момент карта разыгрывается из руки.
	разыгрывается_противником,
	на_столе, ## Карта находится на столе, т.е. становится токеном.
	}
var состояние: Состояние_карты = Состояние_карты.нигде ## Переменная, хранящая в себе [enum Состояние_карты]
var нетление = false

## Идентификатор карты, который используется при обращении к [БазаДанных] для получение информации о карте
var id: String:
	set(значение):
		id = значение
		Атака = Data.дата_карт[id]["атака"]
		Здоровье = Data.дата_карт[id]["здоровье"]
		Возраст = Data.дата_карт[id]["время жизни"]
		озвучка_спавн = load(str("res://Ресурсы/Аудио/Озвучка/спавн_",str(id),".ogg"))
		озвучка_атака = load(str("res://Ресурсы/Аудио/Озвучка/атака_",str(id),".ogg"))
		озвучка_смерть = load(str("res://Ресурсы/Аудио/Озвучка/смерть_",str(id),".ogg"))
		Название = Data.дата_карт[id]["name"]
		Арт = Data.дата_карт[id]["арт"]
		Описание_карты = Data.дата_карт[id]["описание"]
		Тип_карты = load(Data.дата_карт[id]["тип"]).new()
		Редкость = Data.дата_карт[id]["редкость"]
		Стоимость = Data.дата_карт[id]["стоимость"]
		var эффект = []
		for e in Data.дата_карт[id]["эффекты"]:
			эффект.append((load(e).new()))
		ЭФФЕКТЫ.append_array(эффект)
var Название: StringName = "":
	set(значение):
		if значение != null and значение != "":
			Название = значение
			$"Основа_карты/Название".text = Название
			NameFontSize = Namefunc(Название.length())
			$"Основа_карты/Название".font_size = NameFontSize
			@warning_ignore("integer_division")
			$"Основа_карты/Название".outline_size = NameFontSize/3
		else: 
			Название = ""
			$"Основа_карты/Название".text = ""
	get:
		return Название
var Тип_карты: Категории_карт: ## Переменная, хранящая в себе [Категории_карт]
	set(значение):
		Тип_карты = значение
		Тип_карты.подсоединение(self)
		match Тип_карты.Тип_карты:
			Категории_карт.ТИП_КАРТЫ.СУЩЕСТВО:
				текстура = $"Основа_карты/осн_текстура"
				текстура.texture = load("res://Ресурсы/Текстуры и шрифты/Существо_тест.png")
var Редкость: StringName
var ЭФФЕКТЫ: Array[Эффекты] :## Массив [b]изначальных[/b] эффектов карты. Состоит из [Эффекты]
	set(массив):
		
		for e in массив:
			if e.has_method("подсоединение"):
				e.подсоединение(self)
		ЭФФЕКТЫ.append_array(массив)
var Стоимость: int :
	set(значение):
		Стоимость = значение
		$"Основа_карты/Стоимость".text = str(значение) 
var Возраст: int:
	set(значение):
		if значение != null:
			Возраст = значение
			есть_возраст = true
			
			$"Основа_карты/Время".text = str(Возраст)
		else:
			есть_возраст = false
			$"Основа_карты/Время".text = ""
		if значение <= 0:
			смерть()
var Здоровье: int:
	set(значение):
		
		if значение != 0:
			Здоровье = значение
			$"Основа_карты/ХП".text = str(значение)
		elif принадлежность:
			смерть()
		else: смерть_противник()	
var Атака: int:
	set(значение):
		Атака = значение
		$"Основа_карты/Атака".text = str(значение)
var Прочность : int:
	set(значение):
		Прочность = значение
		$"Основа_карты/Прочность".text = str(значение)
var Арт: String :
	set(значение):
		if значение != "":
			Арт = значение
			$"Основа_карты/доп_текстура".texture = load(значение)
		else:
			Арт = "res://Ресурсы/Текстуры и шрифты/заглушка.png"
			$"Основа_карты/доп_текстура".texture = load(Арт)
var текстура 
var Доп_эффект: Array[Эффекты] ## Массив допольнительных эффектов карты. Применяются после изначальных. Состоит из [Эффекты]
var Описание_карты: String :
	set(значение):
		if значение != null and значение != "":
			Описание_карты = значение
			$"Основа_карты/Описание".text = Описание_карты
			DiscFontSize = Discfunc(Описание_карты.length())
			$"Основа_карты/Описание".font_size = DiscFontSize
			@warning_ignore("integer_division")
			$"Основа_карты/Описание".outline_size = DiscFontSize/3
		else:
			Описание_карты = значение
			$"Основа_карты/Описание".text = ""
const NameRatio = 2500 ## Постоянная соотношения размера текста карты к количеству символов
var DiscFontSize: int ## Переменная размера шрифта для описания карты
var NameFontSize: int ## Переменная размера шрифта для названия карты
var новая_позиция : Vector3 ## Рабочая переменная положения карты для метода [method положение_карты]
var новый_поворот : Vector3 ## Рабочая переменная поворота карты для метода [method положение_карты]
var изменение_позиции: bool = false ## Изменяет ли сейчас позицию карта
var Кривая_карты_в_руке: Curve ## Кривая для расчёта положения карты в руке
var меня_хотят_разыграть = false ## Переменная состояния между [enum Состояние_карты] в руке и разыгрывания
@onready var превью = get_tree().current_scene.find_child("Превьюшка", true, false) ## Ссылка на визуализатор превью карты
@onready var превьюКарты = get_tree().current_scene.find_child("Превьюха", true, false) ## Ссылка на ноду [ПревьюКарты] в сцене
var preview = false ## Отображается ли сейчас превью для этой карты
@onready var раб_поз = position ## Переменная для изменения положения только видимой части карты, а не всей её сцены
@onready var Таймер_жизнь:Timer  = $"жизнь" ## Индивидуальный таймер отсчёта жизни карты
var есть_возраст: bool = false ## Имеется ли вообще возраст у этой карты
@onready var маркер = $AAA
@onready var Озвучка = $"Озвучка"
var озвучка_спавн
var озвучка_атака
var озвучка_смерть
func _ready():
	Таймер_жизнь.timeout.connect(таймер_смерть)
func инициализация(ID: StringName = "", Доп_эффекты: Array = []): ## Метод, который заменяет урезанный в возможностях встроенный метод [method Object._init]
	## устанавливаем id карты, а затем и все остальные переменные
	id = ID 
	
	
	
	Доп_эффект.append_array(Доп_эффекты)
	
	
	
	
	match Тип_карты.Тип_карты:
		Тип_карты.ТИП_КАРТЫ.СУЩЕСТВО:
			#Тип_карты.Атака = Data.дата_карт[ID]["атака"]
			#$"Основа_карты/Атака".text = str(Тип_карты.Атака)
			#Тип_карты.Здоровье = Data.дата_карт[ID]["здоровье"]
			#$"Основа_карты/ХП".text = str(Тип_карты.Здоровье)
			#есть_возраст = true
			#Возраст = Data.дата_карт[ID]["время жизни"]
			#Таймер_жизнь = $"жизнь"
			#Таймер_жизнь.timeout.connect(таймер_смерть)
			#$"Основа_карты/Время".text = str(Возраст)
			#$"Основа_карты/осн_текстура".texture = load("res://Ресурсы/Текстуры и шрифты/Существо_тест.png")
			#
			pass
		Тип_карты.ТИП_КАРТЫ.АРТЕФАКТ:
			Тип_карты.Прочность = Data.дата_карт[ID]["прочность"]
			$"Основа_карты/Прочность".text = str(Тип_карты.Прочность)
		Тип_карты.ТИП_КАРТЫ.ЗАКЛИНАНИЕ:
			pass
func положение_карты():
	if $"Основа_карты".position != раб_поз:
		$"Основа_карты".position = $"Основа_карты".position.lerp(раб_поз, .3)
	if position != новая_позиция:
		position = position.lerp(новая_позиция, .3)
	if rotation != новый_поворот:
		rotation_degrees = rotation_degrees.lerp(новый_поворот, .3)
func Discfunc(количество_символов: int) -> int:
	if количество_символов <= 170:
		return 75
	else:
		return 65
func Namefunc(количество_символов: int) -> int: 
	if количество_символов <= 15:
		return 150
	else:
		return -2.5*количество_символов+175
func положить_карту_в_руку():
	if CardManager.КартыВРуке.size() < 10:
		for i in ЭФФЕКТЫ:
			if i.has_method("эффект_при_взятии") == true:
				i.эффект_при_взятии()
		карту_в_руку()
	else:
		сжигание_карты()
func сжигание_карты():
	#смерть()
	print("aaa")
func карту_в_руку():
	CardManager.КартыВРуке.append(self)
	CardManager.позиции_в_руке()
	состояние = Состояние_карты.в_руке
	reparent(get_tree().current_scene.find_child("Рука1", true, false))
	set_meta("polojeniye", состояние)
	
func карту_в_руку_противник():
	CardManager.КартыВРукеПротивника.append(self)
	CardManager.рукаПротивника()
	состояние = Состояние_карты.в_руке_проотивника
	reparent(get_tree().current_scene.find_child("Рука2", true, false))
	set_meta("polojeniye", состояние)

func _process(_delta):
	положение_карты()
	match состояние:
		Состояние_карты.разыгрывается:
			новая_позиция = Мышь3D()
			новый_поворот = get_tree().current_scene.find_child("Рука1", true, false).find_child("позРуки", true, false).rotation
		Состояние_карты.на_столе:
			pass
	match Тип_карты.Тип_карты:
		Категории_карт.ТИП_КАРТЫ.СУЩЕСТВО:
			if Здоровье <= 0:
				смерть()
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
				выкл_превью()
			Состояние_карты.на_столе:
				выкл_превью()
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
						return
				if меня_хотят_разыграть:
					if event is InputEventMouseMotion:
						поз_мыши_2 = get_tree().current_scene.get_viewport().get_mouse_position()
						мышь_расстояние = поз_мышь.distance_to(поз_мыши_2)
						if мышь_расстояние > 500:
							карту_в_мышку()
						return
			Состояние_карты.разыгрывается:
				if CardManager.желание_разыграть:
					if Input.is_action_just_pressed("ЛКМ") or Input.is_action_just_released("ЛКМ"):
						get_viewport().set_input_as_handled()
						
						меня_разыграли.emit(self)
						
						return
				else:
					if Input.is_action_just_pressed("ЛКМ") or Input.is_action_just_released("ЛКМ"):
						get_viewport().set_input_as_handled()
						нерозыгрыш_карты()
						
						return
				if Input.is_action_just_pressed("ПКМ"):
					нерозыгрыш_карты()
					get_viewport().set_input_as_handled()
					return
	if состояние == Состояние_карты.на_столе and принадлежность:
		if Input.is_action_just_pressed("ЛКМ") and Тип_карты.has_method("действие_токена"):
			get_viewport().set_input_as_handled()
			Тип_карты.действие_токена(self)
			pass
				
@warning_ignore("confusable_identifier")
func Мышь3D() -> Vector3:
	
	var камера: Camera3D = get_tree().current_scene.find_child("КАМЕРА", true, false)
	var мышь = get_viewport().get_mouse_position()
	return камера.project_position(мышь, 15)
	

func вкл_превью():
	print("aaa")
	превьюКарты.ресет()
	превьюКарты.создание_карты(id, Название, Описание_карты, Тип_карты, Редкость, ЭФФЕКТЫ, Стоимость, int($"Основа_карты/Прочность".get_text()), int($"Основа_карты/Атака".get_text()), int($"Основа_карты/ХП".get_text()), int($"Основа_карты/Время".get_text()), Арт)
	preview = true
	превью.position = get_tree().current_scene.find_child("КАМЕРА", true, false).unproject_position(position)
	превью.visible = true
	print(превью)
	print(preview)
	print(CardManager.preview)
func выкл_превью():
	превьюКарты.ресет()
	preview = false
	превью.visible = false
	pass

func нерозыгрыш_карты():
	
	
	состояние = Состояние_карты.в_руке
	меня_хотят_разыграть = false
	CardManager.preview = true
	CardManager.обновление_стола()
	CardManager.нерозыгрыш_противник.rpc(я)
func нерозыгрыш_противник():
	состояние = Состояние_карты.в_руке
	меня_хотят_разыграть = false
	CardManager.рукаПротивника()
func карту_в_мышку():
	раб_поз = Vector3(0,0,0)
	состояние = Состояние_карты.разыгрывается
	CardManager.preview = false
	CardManager.разыгрывание_карты = true
	CardManager.картуРазыграть = self
	выкл_превью()
	меня_хотят_разыграть = false
	CardManager.карта_мышка_противник.rpc(я)

func розыгрыш_противник():
	меня_разыграл_противник.emit(self)
	новый_поворот = Vector3(0, 0, 0)
func карту_в_мышку_противника():
	меня_хотят_разыграть = true
	раб_поз = Vector3(0,0,0)
	состояние = Состояние_карты.разыгрывается_противником
	новая_позиция = get_tree().current_scene.find_child("розыгрыш", true, false).position
	новый_поворот = Vector3(0,0,180)
	pass

func проверка_маны(): 
	var моя_мана = GameManager.манаИгрок1
	if Стоимость <= моя_мана:
		return true
	else:
		return false
func таймер_смерть():
	if !нетление:
		Возраст -= 1
		print(Возраст)
		if preview:
			вкл_превью()
func смерть():
	$Area3D.mouse_exited.emit()
	CardManager.preview = true
	global_position = Vector3(0,0,0)
	новая_позиция = Vector3(0,0,0)
	if принадлежность:
		match состояние: 
			Состояние_карты.на_столе:
				GameManager.Карты1.remove_at(GameManager.Карты1.find(self))
				GameManager.позицияТокенов()
				Озвучка.set_stream(озвучка_смерть)
				Озвучка.play()
				умер.emit(self)
			Состояние_карты.в_руке:
				CardManager.КартыВРуке.remove_at(CardManager.КартыВРуке.find(self))
				CardManager.обновление_стола()
		состояние = Состояние_карты.кладбище
		reparent(get_tree().current_scene.find_child("Кладбище", true, false))
	else:
		match состояние: 
			Состояние_карты.на_столе:
				GameManager.Карты2.remove_at(GameManager.Карты2.find(self))
				GameManager.токеныПротивника()
				Озвучка.set_stream(озвучка_смерть)
				Озвучка.play()
				умер.emit(self)
			Состояние_карты.в_руке:
				CardManager.КартыВРукеПротивника.remove_at(CardManager.КартыВРукеПротивника.find(self))
				CardManager.рукаПротивника()
		состояние = Состояние_карты.кладбище
		reparent(get_tree().current_scene.find_child("КладбищеПротивник", true, false))
	
	$Area3D.mouse_exited.emit()
func смерть_противник():
	превью.visible = false
	visible = false	
	match состояние: 
		Состояние_карты.на_столе:
			GameManager.Карты2.remove_at(GameManager.Карты2.find(self))
			GameManager.токеныПротивника()
			Озвучка.set_stream(озвучка_смерть)
			Озвучка.play()
			умер.emit(self)
		Состояние_карты.в_руке:
			CardManager.КартыВРукеПротивника.remove_at(CardManager.КартыВРукеПротивника.find(self))
			CardManager.рукаПротивника()
	состояние = Состояние_карты.кладбище
	reparent(get_tree().current_scene.find_child("КладбищеПротивник", true, false))
	global_position = Vector3(0,0,0)
func обновление_карты():
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
			$"Основа_карты/Атака".text = str(Тип_карты.Атака)
			$"Основа_карты/ХП".text = str(Тип_карты.Здоровье)
			есть_возраст = true
			$"Основа_карты/Время".text = str(Возраст)
	

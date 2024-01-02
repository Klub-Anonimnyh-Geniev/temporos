extends Node

var карта: = preload("res://Сцены/Карта3D.tscn")  
var preview = true
var желание_разыграть = false
var разыгрывание_карты = false
var картуРазыграть
var КартыВРуке: Array
var КартыВРукеПротивника: Array
var СтартоваяКолода: Стартовая_колода = load("res://Ресурсы/Стартовая_колода.tres")
var ИгроваяКолода: Array
var КриваяВРуке_X: Curve = load("res://Ресурсы/позиция_карт_в_руке_X.tres")
var КриваяВРуке_Z: Curve = load("res://Ресурсы/позиция_карт_в_руке_Z.tres")
var КриваяВРуке_поворот: Curve = load("res://Ресурсы/позиция_карт_в_руке_поворот.tres")

# Called when the node enters the scene tree for the first time.
func запуск_матча():
	for i in СтартоваяКолода.Колода.size():
		ИгроваяКолода.append({"id":СтартоваяКолода.Колода[i],
		"доп_эффекты": []})
	var ЗонаРуки:Area2D = get_tree().current_scene.find_child("ЗонаРуки", true, false)
	if ЗонаРуки != null:
		ЗонаРуки.mouse_entered.connect(вернуть_карту)
		ЗонаРуки.mouse_exited.connect(розыгрыш_карты)
func _process(delta):
	if get_tree().current_scene.find_child("КолКарт", true, false) != null:
		if get_tree().current_scene.find_child("КолКарт", true, false).text != str(КартыВРуке.size()):
			get_tree().current_scene.find_child("КолКарт", true, false).text = str(КартыВРуке.size())	

	pass # Replace with function body.
func _unhandled_input(event):
	if event.is_action_pressed("ВзятьКарту"):
		взять_карту(1)
		
	if event.is_action_pressed("Очистить стол"): очистить_стол()
	if event.is_action_pressed("Перемешать колоду"): перемешать_колоду()
	if event.is_action_pressed("Взять карту противник"):
		if not ИгроваяКолода.is_empty(): добавитьКартуВРукуПротивника(ИгроваяКолода[0])
# Called every frame. 'delta' is the elapsed time since the previous frame.

func взять_карту(сколько_взять: int):
	if сколько_взять == 0:
		сколько_взять = 1	
	for взятие_карты in сколько_взять:
		if not ИгроваяКолода.is_empty():
		
			var новая_карта: = карта.instantiate()
			новая_карта.инициализация(ИгроваяКолода[0].get("id"))
			ИгроваяКолода.remove_at(0)
			get_tree().current_scene.find_child("Рука1", true, false).add_child(новая_карта)
			новая_карта.положить_карту_в_руку()
		else: print("карт нет")	

func очистить_стол():
	for картонка in КартыВРуке:
		картонка.выкл_превью()
		ИгроваяКолода.append({"id": картонка.id,"доп_эффекты": картонка.Доп_эффект})
		картонка.queue_free()
	КартыВРуке.clear()
func перемешать_колоду():
	ИгроваяКолода.shuffle()


func позиции_в_руке():
	var ПозРуки = get_tree().current_scene.find_child("Рука1", true, false).find_child("позРуки", true, true).position
	var ПовРуки = get_tree().current_scene.find_child("Рука1", true, false).find_child("позРуки", true, true).rotation
	for карта in КартыВРуке:
		
		if not карта.меня_хотят_разыграть:
			карта.раб_поз = Vector3(0,0,0)
			var коэфРуки = 0.5
			if КартыВРуке.size() > 1:
				коэфРуки = float(КартыВРуке.find(карта))/float(КартыВРуке.size()-1)
			if КартыВРуке.size() < 4:
				карта.новая_позиция = ПозРуки + Vector3(КриваяВРуке_X.sample(коэфРуки) * КартыВРуке.size() * 0.5, КартыВРуке.find(карта) * 0.01,0) 
				карта.новый_поворот = ПовРуки + Vector3(0,0, 0)
			else:
				карта.новая_позиция = ПозРуки + Vector3(КриваяВРуке_X.sample(коэфРуки) * КартыВРуке.size() * 0.4, КартыВРуке.find(карта) * 0.01,КриваяВРуке_Z.sample(коэфРуки) * КартыВРуке.size() * 0.07 ) 
				карта.новый_поворот = ПовРуки + Vector3(0, КриваяВРуке_поворот.sample(коэфРуки) * КартыВРуке.size(), 0)
			print(карта.новая_позиция)
func розыгрыш_карты():
		желание_разыграть = true
func вернуть_карту():
		желание_разыграть = false

func обновление_стола():
	желание_разыграть = false
	разыгрывание_карты = false
	позиции_в_руке()
func рукаПротивника():
	var ПозРуки = get_tree().current_scene.find_child("Рука2", true, false).find_child("позРуки", true, true).position
	var ПовРуки = get_tree().current_scene.find_child("Рука2", true, false).find_child("позРуки", true, true).rotation
	for карта in КартыВРукеПротивника:
		if not карта.меня_хотят_разыграть:
			карта.раб_поз = Vector3(0,0,0)
			var коэфРуки = 0.5
			if КартыВРукеПротивника.size() > 1:
				коэфРуки = float(КартыВРукеПротивника.find(карта))/float(КартыВРукеПротивника.size()-1)
			if КартыВРукеПротивника.size() < 4:
				карта.новая_позиция = ПозРуки + Vector3(-КриваяВРуке_X.sample(коэфРуки) * КартыВРукеПротивника.size() * 0.5, КартыВРукеПротивника.find(карта) * 0.01,0) 
				карта.новый_поворот = ПовРуки + Vector3(0,180, 180)
			else:
				карта.новая_позиция = ПозРуки + Vector3(-КриваяВРуке_X.sample(коэфРуки) * КартыВРукеПротивника.size() * 0.4, КартыВРукеПротивника.find(карта) * 0.01,-КриваяВРуке_Z.sample(коэфРуки) * КартыВРукеПротивника.size() * 0.07 ) 
				карта.новый_поворот = ПовРуки + Vector3(0,180 + КриваяВРуке_поворот.sample(коэфРуки) * КартыВРукеПротивника.size(), 180)
	print(ПозРуки)
	pass
func добавитьКартуВРукуПротивника(айди):
	var новая_карта: = карта.instantiate()
	новая_карта.инициализация(айди.get("id"))
	get_tree().current_scene.find_child("Рука2", true, true).add_child(новая_карта)
	ИгроваяКолода.remove_at(0)
	
	новая_карта.тест_рука_противника()

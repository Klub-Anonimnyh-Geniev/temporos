@tool
extends PanelContainer
class_name Отображение_карты
signal я(я)
signal сохранить_карту(ID, словарь,номер)
var превью = preload("res://addons/редактор_карт/ПревьюКарты.tscn")
var превьюшка
var спрайт 
var Id_надпись
var ID:
	set(a):
		ID = a
		Id_надпись.text = a
var словарь:
	set(значение):
		словарь = значение
		прочность = значение["прочность"]
		тэги = значение["тэг"]
		здоровье = значение["здоровье"]
		арт = значение["арт"]
		атака = значение["атака"]
		название = значение["name"]
		тип = значение["тип"]
		стоимость = значение["стоимость"]
		описание = значение["описание"]
		эффекты = значение["эффекты"]
		время = значение["время жизни"]
		редкость = значение["редкость"]
		pass
 #"стар_призыв": {
	#"name": "Старческий призыв",
	#"тип": "res://Скрипты/Основа/Типы Карт/Заклинания.gd",
	#"редкость": "обычная",
	#"эффекты": [
	#],
	#"стоимость": 1,
	#"атака": null,
	#"здоровье": null,
	#"время жизни": null,
	#"прочность": null,
	#"описание": "Выбранное сущестов получает *Нетление*.",
	#"арт": "res://Ресурсы/Текстуры и шрифты/флейта.png",
	#"тэг": ["хуня)"],



		
var здоровье 
var атака 
var время 
var арт
var тип: String
var название
var описание
var тэги
var эффекты
var стоимость
var редкость
var прочность
var номер
func загрузить_карту(id, данные, индекс):
	Id_надпись = %Label
	спрайт = %"Превью"
	ID = id
	номер = индекс
	словарь = данные
	превьюшка = превью.instantiate()
	$VBoxContainer/CenterContainer/SubViewport.add_child(превьюшка)
	превьюшка.position = Vector3(0,0,-1.8)
	превьюшка.rotation = Vector3(deg_to_rad(90), 0, 0)
	превьюшка.создание_карты(ID, название, описание, тип, редкость, эффекты, стоимость, прочность, атака, здоровье, время, арт)
	я.emit(self)
	CardEditor.получение_информации_от_базы(ID, словарь)
	CardEditor.обновление_от_редактора.connect(обновление_вида)
	pass
func обновление_вида(id, инфа):
	превьюшка.ресет()
	ID = id
	словарь = инфа
	превьюшка.создание_карты(ID, название, описание, тип, редкость, эффекты, стоимость, прочность, атака, здоровье, время, арт)


func сохранить_карту_функ():
	сохранить_карту.emit(ID, словарь, номер)
	pass # Replace with function body.

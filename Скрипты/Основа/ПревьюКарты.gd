@icon("res://Ресурсы/Текстуры и шрифты/превьюкарты.png")
extends Node3D
class_name ПревьюКарты




var id: StringName
var Название: StringName
var Тип_карты: Категории_карт
var Редкость: StringName
var ЭФФЕКТЫ: Array[Эффекты]
var Стоимость: int
var Возраст: int
var Доп_эффект: Array[Эффекты] = []
var Описание_карты: String


var NameRatio = 2500
var DiscFontSize: int
var NameFontSize: int

func создание_карты(ID, название, описание, тип, редкость, эффекты, стоимость, прочность, атака, здоровье, время):
	id = ID
	Название = название
	if описание != null:
		Описание_карты = описание
	Тип_карты = тип
	Редкость = редкость
	if эффекты != null:
		for e in эффекты:
			ЭФФЕКТЫ.append(e)
	Стоимость = стоимость
	$"Основа_карты/Стоимость".text = str(Стоимость)
	if время != null:
		Возраст = время
	
	if описание != null:
		$"Основа_карты/Описание".text = Описание_карты
		DiscFontSize = Discfunc(описание.length())
		$"Основа_карты/Описание".font_size = DiscFontSize
		$"Основа_карты/Описание".outline_size = DiscFontSize/3
	$"Основа_карты/Название".text = Название
	NameFontSize = Namefunc(Название.length())
	$"Основа_карты/Название".font_size = NameFontSize
	$"Основа_карты/Название".outline_size = NameFontSize/3
	match Тип_карты.Тип_карты:
		Тип_карты.ТИП_КАРТЫ.СУЩЕСТВО: 
			if атака != null:
				Тип_карты.Атака = атака
			if здоровье != null:
				Тип_карты.Здоровье = здоровье
			if время != null:
				Возраст = время
			$"Основа_карты/ХП".text = str(Тип_карты.Здоровье)
			$"Основа_карты/Атака".text = str(Тип_карты.Атака)
			$"Основа_карты/Время".text = str(Возраст)
		Тип_карты.ТИП_КАРТЫ.АРТЕФАКТ:
			if прочность != null:
				Тип_карты.Прочность = прочность
			$"Основа_карты/ХП".text = str(Тип_карты.Прочность)
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

func ресет():
	id = ""
	Название = ""
	
	Описание_карты = ""
	Тип_карты = null
	Редкость = ""
	ЭФФЕКТЫ.clear()

	$"Основа_карты/Описание".text = ""
	$"Основа_карты/Название".text = ""
	$"Основа_карты/ХП".text = ""
	$"Основа_карты/Атака".text =""
	$"Основа_карты/Время".text = ""
	$"Основа_карты/ХП".text = ""
	$"Основа_карты/Стоимость".text = ""

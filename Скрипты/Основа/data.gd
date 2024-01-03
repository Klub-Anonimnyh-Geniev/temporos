extends Node
##Этот файл подгружает данные обо всех карт
class_name БазаДанных




var дата_карт ## Переменная для файла [JSON], используемого как база данных всех карт

func _ready():
	дата_карт = импорт_даты("res://Ресурсы/датабаза.json")
	pass




func импорт_даты(путь: String): ## Данный метод открывает файл [JSON] по заданному [param пути]
	var дата_файл = FileAccess.open(путь, FileAccess.READ)
	var дата_json = JSON.parse_string(дата_файл.get_as_text())
	
	дата_файл.close()
	
	var дата_вывод = дата_json
	return(дата_вывод)

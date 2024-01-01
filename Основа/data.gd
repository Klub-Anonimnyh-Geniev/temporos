extends Node
##Этот файл подгружает данные обо всех карт



var дата_карт

func _ready():
	дата_карт = импорт_даты("res://Основа/датабаза.json")
	pass




func импорт_даты(путь: String):
	var дата_файл = FileAccess.open(путь, FileAccess.READ)
	var дата_json = JSON.parse_string(дата_файл.get_as_text())
	
	дата_файл.close()
	
	var дата_вывод = дата_json
	return(дата_вывод)

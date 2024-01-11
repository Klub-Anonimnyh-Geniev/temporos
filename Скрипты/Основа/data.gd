extends Node
##Этот файл подгружает данные обо всех карт
class_name БазаДанных

@export_category("База игроков")
@export var все_игроки = {
	"sancho": {"ник": "Санчо", "деки": []},
	"corbinadtor": {"ник": "Левый", "деки": []},
	}

var дата_карт ## Переменная для файла [JSON], используемого как база данных всех карт

func _ready():
	дата_карт = импорт_даты("res://Ресурсы/датабаза.json")
	pass


func вход_пользователя(логин):
	if все_игроки.has(логин):
		print("добрый вечер, ", все_игроки.get(логин).get("ник"))
		return [true, все_игроки.get(логин)]
	else: return [false, "Игрок не найден"]

func импорт_даты(путь: String): ## Данный метод открывает файл [JSON] по заданному [param пути]
	var дата_файл = FileAccess.open(путь, FileAccess.READ)
	var дата_json = JSON.parse_string(дата_файл.get_as_text())
	
	дата_файл.close()
	
	var дата_вывод = дата_json
	return(дата_вывод)

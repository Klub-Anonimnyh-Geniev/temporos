extends Node
class_name Категории_карт
enum ТИП_КАРТЫ {СУЩЕСТВО, ЗАКЛИНАНИЕ, АРТЕФАКТ}

var Тип_карты: ТИП_КАРТЫ
func подсоединение(путь: Карта):
	путь.меня_разыграли.connect(розыгрыш_карты)
func _init():
	
	
	
	pass
func розыгрыш_карты(карта: Карта):
	print(карта.id)
	pass

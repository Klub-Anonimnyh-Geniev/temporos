extends Категории_карт
class_name Существо
## Ресурс карты подкласса [Существо], отображающий показатель урона при атаке этим существом
@export var Атака: int

## Ресурс карты подкласса [Существо], который тратится при получении урона
@export var Здоровье: int
var я
##Автоматическая установка типа карты
func _init():
	Тип_карты = ТИП_КАРТЫ.СУЩЕСТВО
	pass
	
func розыгрыш_карты(карта):
	if GameManager.Карты1.size() < 7:
		я = карта
		GameManager.манаИгрок1 -= карта.Стоимость
		CardManager.КартыВРуке.remove_at(CardManager.КартыВРуке.find(карта))
		CardManager.preview = true
		карта.состояние = Карта.Состояние_карты.на_столе
		set_meta("polojeniye", карта.состояние)
		var index: int = 0
		for токен in GameManager.Карты1:
			
			var камера = карта.get_tree().current_scene.find_child("КАМЕРА", true, false)
			var мышь = карта.get_viewport().get_mouse_position()
			if камера.unproject_position(токен.global_position).x <= мышь.x:
				index +=1
			pass
		
		GameManager.Карты1.insert(index, карта)
		карта.reparent(карта.get_tree().current_scene.find_child("Карты1", true, false))
		GameManager.позицияТокенов()
		CardManager.обновление_стола()
		карта.preview = false
		if карта.есть_возраст:
			карта.Таймер_жизнь.start()
		CardManager.противник_разыграл.rpc(карта.я)
		карта.set_meta("type", карта.Тип_карты.Тип_карты)

func розыгрыш_противником(карта):
	if GameManager.Карты2.size() < 7:
		я = карта
		GameManager.манаИгрок2 -= карта.Стоимость
		CardManager.КартыВРукеПротивника.remove_at(CardManager.КартыВРукеПротивника.find(карта))
		карта.состояние = Карта.Состояние_карты.на_столе
		set_meta("polojeniye", карта.состояние)
		GameManager.Карты2.push_front(карта)
		карта.reparent(карта.get_tree().current_scene.find_child("Карты2", true, false))
		GameManager.токеныПротивника()
		CardManager.рукаПротивника()
		карта.preview = false
		if карта.есть_возраст:
			карта.Таймер_жизнь.start()
		карта.set_meta("type", карта.Тип_карты.Тип_карты)

func действие_токена(актор):
	if !CardManager.выбор_цели:
		var выбор = Выбор_цели.new()
		выбор.тип_таргета = {"type": ТИП_КАРТЫ.СУЩЕСТВО, "принадлежность": false}
		выбор.выбор_цели.connect(запрос_атаки)
		актор.get_tree().current_scene.add_child(выбор)
		выбор.актор = я
		выбор.метод = self
		выбор.создание()
	
func атака(цель: Карта):
	цель.Тип_карты.Здоровье -= Атака
	Здоровье -= цель.Тип_карты.Атака
	CardManager.обновление_карт()
	pass

func запрос_атаки(цель):
	атака(цель)
	CardManager.передать_атаку.rpc(я.я, цель.я)


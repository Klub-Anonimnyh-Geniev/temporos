extends Категории_карт
class_name Существо
## Ресурс карты подкласса [Существо], отображающий показатель урона при атаке этим существом
@export var Атака: int

## Ресурс карты подкласса [Существо], который тратится при получении урона
@export var Здоровье: int

##Автоматическая установка типа карты
func _init():
	Тип_карты = ТИП_КАРТЫ.СУЩЕСТВО
	pass
	
func розыгрыш_карты(карта):
	if GameManager.Карты1.size() < 7:
		GameManager.манаИгрок1 -= карта.Стоимость
		CardManager.КартыВРуке.remove_at(CardManager.КартыВРуке.find(карта))
		CardManager.preview = true
		карта.состояние = Карта.Состояние_карты.на_столе
		set_meta("polojeniye", карта.состояние)
		GameManager.Карты1.append(карта)
		карта.reparent(карта.get_tree().current_scene.find_child("Карты1", true, false))
		GameManager.позицияТокенов()
		CardManager.обновление_стола()
		карта.preview = false
		if карта.есть_возраст:
			карта.Таймер_жизнь.start()

extends Эффекты
class_name Боевой_клич

## Подкласс [Эффекты]
##
## Особенность этого подкласса в срабатывании эффекта [br]
## при разыгрывании карты из руки




func _init():
	##Автоматическая установка типа эффекта
	Тип_эффекта = ТИП_ЭФФЕКТА.КЛИЧ
	pass
	
## Функция подкласса [Боевой_клич].
##
## В момент вызова срабатывания Боевого клича будет вызываться именно эта функция эффекта
func боевой_клич():
	pass

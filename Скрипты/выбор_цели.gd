extends Node
class_name Выбор_цели
var стрелка = load("res://Сцены/стрелкапуть.tscn")
var актор
var цель
var СТРЕЛА
var метод
var тип_таргета = {}
var текущий_таргет = {}
signal выбор_цели(цель)

func создание():
	
	CardManager.выбор_цели = true
	СТРЕЛА = стрелка.instantiate()
	СТРЕЛА.актор = актор
	актор.get_tree().current_scene.add_child(СТРЕЛА)
	СТРЕЛА.global_position = Vector3(0,0,0)
	СТРЕЛА.готовность()
	
func _input(event):
	if event.is_action_pressed("ПКМ"):
		окончание()
	if event.is_action_pressed("ЛКМ"):
		проверка_цели()


func проверка_цели():
	if СТРЕЛА.цель != null:
		for условие in тип_таргета:
			match условие:
				"type":
					if СТРЕЛА.цель.has_meta("type"):
						текущий_таргет["type"] = СТРЕЛА.цель.get_meta("type")
					else: return
				"принадлежность":
					текущий_таргет["принадлежность"] = СТРЕЛА.цель.принадлежность
		if тип_таргета == текущий_таргет:
			выбор_цели.emit(СТРЕЛА.цель)
			окончание()

func окончание():
	СТРЕЛА.queue_free()
	CardManager.выбор_цели = false
	queue_free()

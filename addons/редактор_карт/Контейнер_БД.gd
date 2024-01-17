@tool
extends Control
var индекс: int
var база
var новая_база: Dictionary
var лист_карт
var список_карт: Array[String]
var название_бд
var карта
var окно_id
var окно_ошибка_id
var окно_ошибка_сохранения
var окно_удалить
var кнопка_новая_карта
var кнопка_сохранить_карту
var кнопка_удалить_карту
func _enter_tree():
	окно_удалить = $"VBoxContainer/удаление"
	окно_ошибка_сохранения = $"VBoxContainer/ошибка"
	лист_карт = %"Лист_карт"
	название_бд = $VBoxContainer/Label
	окно_id = $"Ввод_нового_id"
	окно_ошибка_id = $"Ввод_нового_id/ошибка_id"
	кнопка_новая_карта = $"VBoxContainer/Новая_карта"
	кнопка_сохранить_карту = $"VBoxContainer/Сохранить_карту"
	кнопка_удалить_карту = $"VBoxContainer/Удалить_карту"
	окно_удалить.confirmed.connect(удаление_карты)
	pass

func _exit_tree():
	if карта:
		кнопка_сохранить_карту.pressed.disconnect(карта.сохранить_карту_функ)
		карта.free()
	окно_удалить.confirmed.disconnect(удаление_карты)	
	
func выбор_карты(id):
	if $"../Карта/".get_child_count() > 0:
		$"../Карта".get_child(0).queue_free()
	карта = load("res://addons/редактор_карт/отображение_карты.tscn").instantiate()
	карта.загрузить_карту(список_карт[id], база[список_карт[id]], id)
	$"../Карта".add_child(карта)
	кнопка_сохранить_карту.pressed.connect(карта.сохранить_карту_функ)
	карта.сохранить_карту.connect(сохранить_карту)
	
	CardEditor.карта = true
	CardEditor.словарь = база[список_карт[id]]
	CardEditor.ID = список_карт[id]
	кнопка_удалить_карту.disabled = false
	кнопка_сохранить_карту.disabled = false
	pass
func удалить_карту():
	окно_удалить.popup()
	
	pass
func удаление_карты():
	лист_карт.remove_item(карта.номер)
	база.erase(карта.ID)
	список_карт.erase(карта.ID)
	карта.queue_free()
	CardEditor.карта = false
	кнопка_сохранить_карту.disabled = true
	кнопка_удалить_карту.disabled = true
	
	pass
func сохранить_карту(айди, дата, index):
	if список_карт[index] == айди:
		var индекс: int = 0
		for i in список_карт:
			if индекс == index:
				
				новая_база[айди] = дата
				лист_карт.set_item_text(index, айди)
				лист_карт.set_item_icon(index, load(дата["арт"]))
			else:
				новая_база[i] = база[i]
			индекс += 1
		
		база = новая_база
	else:
		if список_карт.find(айди) >= 0:
			окно_ошибка_сохранения.dialog_text = "Ошибка, выбранный ID занят. придумайте другой идентификатор"
			окно_ошибка_сохранения.popup()
			return
		elif айди == "":
			окно_ошибка_сохранения.dialog_text = "Ошибка, ID не может быть пустым"
			окно_ошибка_сохранения.popup()
			return
		else: 
			var индекс: int = 0
			for i in список_карт:
				if индекс == index:
					новая_база[айди] = дата
					список_карт[index] = айди
					лист_карт.set_item_text(index, айди)
					лист_карт.set_item_icon(index, load(дата["арт"]))
				else:
					новая_база[i] = база[i]
				индекс += 1
			база = новая_база
	
func новая_карта(id):
	if $"../Карта/".get_child_count() > 0:
		$"../Карта".get_child(0).queue_free()
	список_карт.append(id)
	база[id] = {
		"name": "Новая карта",
		"тип": "res://Скрипты/Основа/Типы Карт/Существо.gd",
		"редкость": "обычная",
		"эффекты": [],
		"стоимость": null,
		"атака": null,
		"здоровье": null,
		"время жизни": null,
		"прочность": null,
		"описание": "Описание карты",
		"арт": "res://Ресурсы/Текстуры и шрифты/заглушка.png",
		"тэг": [],
	}
	var index = лист_карт.add_item(id, load("res://addons/редактор_карт/карта_заглушка.png"))
	выбор_карты(index)
	лист_карт.select(index)
	pass

func открыть_бд(бд):
	кнопка_новая_карта.disabled = false
	
	лист_карт.clear()
	список_карт.clear()
	CardEditor.карта = false
	база = str_to_var(бд)
	for карта in база:
		var иконка = load("res://addons/редактор_карт/карта_заглушка.png")
		if база[карта]["арт"] != "":
			иконка = load(база[карта]["арт"])
		лист_карт.add_item(карта, иконка)
		список_карт.append(карта)
		
	pass
func закрыть():
	лист_карт.clear()
	if $"../Карта/".get_child_count() > 0:
		$"../Карта".remove_child($"../Карта".get_child(0))
	база.clear()
	кнопка_новая_карта.disabled = true
	список_карт.clear()
	новая_база.clear()
	CardEditor.словарь.clear()
	CardEditor.карта = false
	pass
func сохранить_базу():
	pass


func _on_ввод_нового_id_confirmed():
	var ввод = $"Ввод_нового_id/Control/LineEdit".text
	if ввод == "":
		окно_ошибка_id.dialog_text = "ID не может быть пустым"
		окно_ошибка_id.popup()
		return
	for айди in список_карт:
		if ввод == айди:
			окно_ошибка_id.dialog_text = "ID занят, выберите другой"
			окно_ошибка_id.popup()
			return
	новая_карта(ввод)
	окно_id.hide()
	pass # Replace with function body.


func _on_новая_карта_pressed():
	
	окно_id.popup()
	pass # Replace with function body.

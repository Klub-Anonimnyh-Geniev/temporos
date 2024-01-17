@tool
extends Control

signal обновление_базы(id, инфа)


var заглушка
var заглушка_стоит = false
var есть_карта = false
var карта
var ID
var ID_текст
var Название_текст
var Описание_текст
var Арт_текст
var Арт_кнопка
var Атака_текст
var Здоровье_текст
var Прочность_текст
var Время_текст
var Стоимость_редактор
var тип_выбор 
func _enter_tree():
	тип_выбор = $"VBoxContainer/Тип/Тип_выбор"
	тип_выбор.get_popup().id_pressed.connect(выбор_типа)
	for тип in Категории_карт.ТИП_КАРТЫ:
		тип_выбор.get_popup().add_item(тип)
		
	заглушка = $"Заглушка"
	заглушка.show()
	заглушка_стоит = true
	ID_текст = $"VBoxContainer/ID/ID_редактор"
	Название_текст = $"VBoxContainer/Название/Название_редактор"
	Описание_текст = $"VBoxContainer/Описание/Описание_редактор"
	Арт_текст = $"VBoxContainer/Арт/Panel2/Арт_отображение"
	Арт_кнопка = $"VBoxContainer/Арт/Арт_выбор"
	Атака_текст = $"VBoxContainer/Атака/Атака_редактор"
	Здоровье_текст = $"VBoxContainer/Здоровье/Здоровье_редактор"
	Прочность_текст = $"VBoxContainer/Прочность/Прочность_редактор"
	Время_текст = $"VBoxContainer/Время/Время_редактор"
	Стоимость_редактор = $"VBoxContainer/Стоимость/Стоимость_редактор"
	CardEditor.обновление_от_базы.connect(обновление_инфы_от_базы)
	обновление_базы.connect(CardEditor.получение_информации_от_редактора)
	$"ВыборФайла".file_selected.connect(загрузка_пикчи)
func _process(delta):
	if !CardEditor.карта:
		if !заглушка_стоит:
			заглушка.show()
			заглушка_стоит = true
	else:
		if заглушка_стоит:
			заглушка.hide()
			заглушка_стоит = false

func _exit_tree():
	заглушка_стоит = true
	CardEditor.обновление_от_базы.disconnect(обновление_инфы_от_базы)
	обновление_базы.disconnect(CardEditor.получение_информации_от_редактора)
	$"ВыборФайла".file_selected.disconnect(загрузка_пикчи)
	тип_выбор.get_popup().id_pressed.disconnect(выбор_типа)
	тип_выбор.get_popup().clear()
func обновление_инфы_от_базы(id, инфа):
	карта = инфа
	ID = id
	ID_текст.text = ID
	Название_текст.text = инфа["name"]
	обновить_тип(инфа["тип"])
	Здоровье_текст.text = str(карта["здоровье"])
	Здоровье_текст.editable = карта["здоровье"] != null
	$"VBoxContainer/Здоровье/Panel/Здоровье_кнопка".button_pressed = карта["здоровье"] != null
	Атака_текст.text = str(карта["атака"])
	Атака_текст.editable = карта["атака"] != null
	$"VBoxContainer/Атака/Panel/Атака_кнопка".button_pressed = карта["атака"] != null
	Стоимость_редактор.text = str(карта["стоимость"])
	Стоимость_редактор.editable = карта["стоимость"] != null
	$"VBoxContainer/Стоимость/Panel/Стоимость_кнопка".button_pressed = карта["стоимость"] != null
	Арт_текст.text = карта["арт"]
	Описание_текст.text = карта["описание"]
	Описание_текст.editable = карта["описание"] != null
	$"VBoxContainer/Описание/Panel/Описание_кнопка".button_pressed = карта["описание"] != null
	Время_текст.text = str(карта["время жизни"])
	Время_текст.editable = карта["время жизни"] != null
	$"VBoxContainer/Время/Panel/Время_кнопка".button_pressed = карта["время жизни"] != null
	Прочность_текст.text = str(карта["прочность"])
	Прочность_текст.editable = карта["прочность"] != null
	$"VBoxContainer/Прочность/Panel/Прочность_кнопка".button_pressed = карта["прочность"] != null
	
	
	pass
func обновить_тип(путь):
	match путь:
		"res://Скрипты/Основа/Типы Карт/Существо.gd":
			тип_выбор.text = "СУЩЕСТВО"
		"res://Скрипты/Основа/Типы Карт/Заклинания.gd":
			тип_выбор.text = "ЗАКЛИНАНИЕ"
		"res://Скрипты/Основа/Типы Карт/САртефакт.gd":
			тип_выбор.text = "АРТЕФАКТ"
		_:
			тип_выбор.text = "СУЩЕСТВО"
	pass
func обновить_базу():
	обновление_базы.emit(ID, карта)
	pass

func выбор_типа(id):
	match id:
		Категории_карт.ТИП_КАРТЫ.СУЩЕСТВО:
			тип_выбор.text = "СУЩЕСТВО"
			карта["тип"] = "res://Скрипты/Основа/Типы Карт/Существо.gd"
			pass
		Категории_карт.ТИП_КАРТЫ.ЗАКЛИНАНИЕ:
			тип_выбор.text = "ЗАКЛИНАНИЕ"
			карта["тип"] = "res://Скрипты/Основа/Типы Карт/Заклинания.gd"
			pass
		Категории_карт.ТИП_КАРТЫ.АРТЕФАКТ:
			тип_выбор.text = "АРТЕФАКТ"
			карта["тип"] = "res://Скрипты/Основа/Типы Карт/Артефакт.gd"
			pass
		_:
			тип_выбор.text = "СУЩЕСТВО"
			карта["тип"] = "res://Скрипты/Основа/Типы Карт/Существо.gd"
			pass
	обновить_базу()
func _on_id_редактор_text_changed(new_text):
	ID = new_text
	обновить_базу()
	pass # Replace with function body.


func _on_название_редактор_text_changed(new_text):
	карта["name"] = new_text
	обновить_базу()
	pass # Replace with function body.


func _on_описание_редактор_text_changed():
	карта["описание"] = Описание_текст.text
	обновить_базу()
	pass # Replace with function body.


func _on_арт_выбор_pressed():
	$"ВыборФайла".popup()
	pass # Replace with function body.


func _on_атака_редактор_text_changed(new_text):
	карта["атака"] = int(new_text)
	обновить_базу()
	pass # Replace with function body.


func _on_здоровье_редактор_text_changed(new_text):
	карта["здоровье"] = int(new_text)
	обновить_базу()
	pass # Replace with function body.


func _on_прочность_редактор_text_changed(new_text):
	карта["прочность"] = int(new_text)
	обновить_базу()
	pass # Replace with function body.


func _on_время_редактор_text_changed(new_text):
	карта["время жизни"] = int(new_text)
	обновить_базу()
	pass # Replace with function body.


func _on_стоимость_редактор_text_changed(new_text):
	карта["стоимость"] = int(new_text)
	обновить_базу()
	pass # Replace with function body.




func _on_описание_кнопка_toggled(toggled_on):
	Описание_текст.editable = toggled_on
	if !toggled_on:
		карта["описание"] = ""
		обновить_базу()
	pass # Replace with function body.


func _on_атака_кнопка_toggled(toggled_on):
	Атака_текст.editable = toggled_on
	if !toggled_on:
		карта["атака"] = null
	else: карта["атака"] = int(Атака_текст.text)
	обновить_базу()
	pass # Replace with function body.


func _on_здоровье_кнопка_toggled(toggled_on):
	Здоровье_текст.editable = toggled_on
	if !toggled_on:
		карта["здоровье"] = null
	else: карта["здоровье"] = int(Здоровье_текст.text)
	обновить_базу()
	pass # Replace with function body.


func _on_прочность_кнопка_toggled(toggled_on):
	Прочность_текст.editable = toggled_on
	if !toggled_on:
		карта["прочность"] = null
	else: карта["прочность"] = int(Прочность_текст.text)
	обновить_базу()
	pass # Replace with function body.

func загрузка_пикчи(путь):
	Арт_текст.text = путь
	карта["арт"] = путь
	обновить_базу()
	pass

func _on_время_кнопка_toggled(toggled_on):
	Время_текст.editable = toggled_on
	if !toggled_on:
		карта["время жизни"] = null
	else: карта["время жизни"] = int(Время_текст.text)
	обновить_базу()
	pass # Replace with function body.


func _on_стоимость_кнопка_toggled(toggled_on):
	Стоимость_редактор.editable = toggled_on
	if !toggled_on:
		карта["стоимость"] = null
	else: карта["стоимость"] = int(Стоимость_редактор.text)
	обновить_базу()
	pass # Replace with function body.

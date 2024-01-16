@tool
extends Control
var база_файл
var база
var путь_база
var Кнопка_создать_бд: Button 
var Кнопка_открыть_бд: Button 
var Кнопка_сохранить_бд: Button
var Кнопка_сохранить_бд_как: Button
var Кнопка_закрыть: Button
var ВыборФайла: FileDialog 
var КонтейнерБД
signal открыть_бд(бд)
func _enter_tree():
	Кнопка_создать_бд =  $"VBoxContainer/Menu/Создать"
	Кнопка_открыть_бд = $"VBoxContainer/Menu/Открыть"
	ВыборФайла = $"ВыборФайла"
	КонтейнерБД = $"VBoxContainer/Редактор/HSplitContainer/БазаДанных"
	Кнопка_сохранить_бд = $"VBoxContainer/Menu/Сохранить"
	Кнопка_сохранить_бд_как = $"VBoxContainer/Menu/Сохранить_как"
	Кнопка_закрыть = $"VBoxContainer/Menu/Закрыть"
	
	pass


func выбор_файла(путь):
	
	путь_база = путь
	база_файл = FileAccess.open(путь, FileAccess.READ)
	база = база_файл.get_as_text()
	открыть_бд.emit(база)
	Кнопка_сохранить_бд.disabled = false
	Кнопка_закрыть.disabled = false
	база_файл.close()

func открыть_базу_данных():
	if база_файл is FileAccess:
		база_файл.close()
		база_файл = null
	ВыборФайла.popup()
	pass
func сохранить_базу_данных():
	база_файл = FileAccess.open(путь_база, FileAccess.WRITE)
	var json_save = JSON.stringify(КонтейнерБД.база)
	база_файл.store_string(json_save)
	база_файл.close()
	
	pass
func закрыть():
	база_файл.close()
	база_файл = null
	база = {}
	Кнопка_сохранить_бд.disabled = true
	Кнопка_закрыть.disabled = true
	КонтейнерБД.закрыть()
	
	pass

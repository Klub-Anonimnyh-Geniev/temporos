@tool
extends EditorPlugin
var панель
var настройка
var путь_экспорта
var путь_импорта
#region Обложка
func _enter_tree():
	панель = preload("res://addons/редактор_карт/редактор.tscn").instantiate()

	EditorInterface.get_editor_main_screen().add_child(панель)
	_make_visible(false)
	
	add_autoload_singleton("CardEditor", "res://addons/редактор_карт/CardEditor.gd")
	# Initialization of the plugin goes here.
	
	панель.ВыборФайла.file_selected.connect(панель.выбор_файла)
	панель.Кнопка_открыть_бд.pressed.connect(панель.открыть_базу_данных)
	панель.Кнопка_сохранить_бд.pressed.connect(панель.сохранить_базу_данных)
	панель.открыть_бд.connect(панель.КонтейнерБД.открыть_бд)
	панель.Кнопка_закрыть.pressed.connect(панель.закрыть)
	панель.КонтейнерБД.лист_карт.item_selected.connect(панель.КонтейнерБД.выбор_карты)
	pass


func _exit_tree():
	if панель:
		панель.queue_free()
		
	if настройка:
		настройка.queue_free()
	# Clean-up of the plugin goes heвre.
	pass


func _has_main_screen():
	return true


func _make_visible(visible):
	if панель:
		панель.visible = visible
		if visible:
			настройка = preload("res://addons/редактор_карт/настройка карты.tscn").instantiate()
			add_control_to_dock(EditorPlugin.DOCK_SLOT_RIGHT_UL, настройка)
		else:
			if настройка:
				настройка.queue_free()
		



func _get_plugin_icon():
	return load("res://addons/редактор_карт/карта.png")

func _get_plugin_name():
	return "Редактор карт"
#endregion


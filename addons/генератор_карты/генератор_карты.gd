@tool
extends EditorPlugin

var панель
var условие
var путь_экспорта
var путь_импорта
#region Обложка
func _enter_tree():
	панель = preload("res://addons/генератор_карты/генератор_карты.tscn").instantiate()
	EditorInterface.get_editor_main_screen().add_child(панель)
	_make_visible(false)
	# Initialization of the plugin goes here.
	
	pass


func _exit_tree():
	if панель:
		панель.queue_free()
	# Clean-up of the plugin goes heвre.
	pass


func _has_main_screen():
	return true


func _make_visible(visible):
	if панель:
		панель.visible = visible




func _get_plugin_icon():
	return load("res://addons/генератор_карты/карта.png")

func _get_plugin_name():
	return "Генератор карты"
#endregion


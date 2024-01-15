extends Node
#https://youtu.be/xhZ3FWUkhKY
enum Команды {взять_карту, выйти, изменить_ману}
var режим_консоли = false
@onready var Поле = $LineEdit

func _input(event):
	if event.is_action_pressed("Консоль") and !режим_консоли:
		get_viewport().set_input_as_handled() 
		режим_консоли = true
		Поле.set_focus_mode(2)
		Поле.grab_focus()
		Поле.clear()
		Поле.visible = true
	if event.is_action_pressed("Выйти") and режим_консоли:
		Поле.set_focus_mode(0)
		Поле.clear()
		Поле.visible = false
		режим_консоли = false
	if event.is_action_pressed("Таб") and режим_консоли:
		автоподсказка()
		pass
	pass
func _on_line_edit_text_submitted(строка : String):
	строка = строка.lstrip(" ").rstrip(" ")
	var пробелы: int = строка.find(" ")
	var команда : String
	var значение : String
	
	if пробелы == -1:
		команда = строка.to_lower()
	else:
		команда = строка.substr(0, пробелы).to_lower()
		значение = строка.substr(пробелы)
		значение = значение.lstrip(" ")
	выполнение_команды(команда, значение)
	
	
	
func выполнение_команды(команда:String, значение:String):
	if Команды.get(команда) != null:
		match Команды.get(команда):
			Команды.взять_карту:
				CardManager.взять_карту(int(значение))
				print(значение)
				pass
			Команды.выйти:
				GameManager.закрыть_игру()
				pass
			Команды.изменить_ману:
				GameManager.изменить_ману(значение)
				pass
	else:
		print("Ошибка, команда не существует")
	Поле.clear()
		
	pass # Replace with function body.

func автоподсказка():
	pass

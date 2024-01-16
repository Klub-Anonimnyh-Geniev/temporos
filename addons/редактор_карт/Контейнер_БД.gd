@tool
extends Control
var база
var новая_база: Dictionary
var лист_карт
var список_карт: Array[String]
var название_бд
var кнопка
var карта
func _enter_tree():
	лист_карт = %"Лист_карт"
	название_бд = $VBoxContainer/Label
	кнопка = $VBoxContainer/Button
	pass

func _exit_tree():
	if карта:
		карта.free()

func выбор_карты(id):
	if $"../Карта/".get_child_count() > 0:
		$"../Карта".remove_child($"../Карта".get_child(0))
	карта = load("res://addons/редактор_карт/отображение_карты.tscn").instantiate()
	карта.загрузить_карту(список_карт[id], база[список_карт[id]], id)
	$"../Карта".add_child(карта)
	карта.сохранить_карту.connect(сохранить_карту)
	CardEditor.карта = true
	CardEditor.словарь = база[список_карт[id]]
	CardEditor.ID = список_карт[id]
	pass

func сохранить_карту(id, дата, index):
	
	if список_карт[index] == id:
		var индекс: int = 0
		for i in список_карт:
			if индекс == index:
				
				новая_база[id] = дата
				лист_карт.set_item_text(index, id)
			else:
				новая_база[i] = база[i]
			индекс += 1
		
		база = новая_база
	else:
		if список_карт.find(id) >= 0:
			print("Ошибка, выбранный ID занят. придумайте другой идентификатор")
			return
		else: 
			var индекс: int = 0
			for i in список_карт:
				if индекс == index:
					новая_база[id] = дата
					список_карт[index] = id
					лист_карт.set_item_text(index, id)
				else:
					новая_база[i] = база[i]
				индекс += 1
			база = новая_база
	
func новая_карта():
	pass

func открыть_бд(бд):
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
	список_карт.clear()
	новая_база.clear()
	CardEditor.словарь.clear()
	CardEditor.карта = false
	pass
func сохранить_базу():
	pass

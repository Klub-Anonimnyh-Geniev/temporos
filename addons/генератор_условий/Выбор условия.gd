@tool
class_name КастомныйВыбор
extends HBoxContainer
var список_выборов = [
	"Тип",
	"Принадлежность",
	"Расположение",
	"Характеристика",
]
var значения
var менюшка: OptionButton
func _enter_tree():
	менюшка = $"HBoxContainer/Выбор"
	for i in список_выборов:
		менюшка.add_item(i)
	
func выполнение_выбора(выбор):
	значения = список_выборов[выбор]
	pass

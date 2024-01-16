extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	mouse_entered.connect(наведение_на_мышку)
	pressed.connect(нажатие)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func наведение_на_мышку():
	get_tree().current_scene.проигрывание_звука_интерфейса("наводка")
	pass
func нажатие():
	get_tree().current_scene.проигрывание_звука_интерфейса("нажатие")

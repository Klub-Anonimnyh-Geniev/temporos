extends Button


# Called when the node enters the scene tree for the first time.
func _ready():
	connect("button_down", GameManager.контроль_стадии)




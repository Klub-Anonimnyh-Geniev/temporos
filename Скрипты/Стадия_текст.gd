extends Label


# Called when the node enters the scene tree for the first time.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	text = GameManager.Стадия_матча_тип.find_key(GameManager.стадия_матча)
	

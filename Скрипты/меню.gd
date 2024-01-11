extends Node
var лобби = preload("res://Сцены/проверка.tscn")
var ядро 
# Called when the node enters the scene tree for the first time.
func _ready():
	print(ядро)
	%"выход".pressed.connect(GameManager.закрыть_игру)
	%"создать_лобби".pressed.connect(создать_лобби)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func создать_лобби():
	var матч = лобби.instantiate()
	ядро.add_child(матч)
	GameManager.подготовить_матч()
	queue_free()
	

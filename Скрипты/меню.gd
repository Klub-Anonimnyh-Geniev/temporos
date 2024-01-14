extends Node
var лобби = preload("res://Сцены/проверка.tscn")
var ядро 
# Called when the node enters the scene tree for the first time.
func _ready():
	NetMenager.начало_игры.connect(func(): queue_free())
	%"выход".pressed.connect(GameManager.закрыть_игру)
	%"создать_лобби".pressed.connect(создать_лобби)
	%"зайти_в_лобби".pressed.connect(вход_в_лобби)
	%"начать".pressed.connect(func(): NetMenager.начать_игру.rpc())
	$"Интерфейс_меню/Control/MarginContainer/Кнопки_меню/IP".text_changed.connect(ввод_айпи.bind())
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func создать_лобби():
	
	#
	NetMenager.создание_лобби()
	%"начать".disabled = false
	%"создать_лобби".disabled=true
	%"зайти_в_лобби".disabled=true
func вход_в_лобби():
	NetMenager.зайти_в_лобби()
	%"начать".disabled = false
	%"создать_лобби".disabled=true
	%"зайти_в_лобби".disabled=true
	
func ввод_айпи(айпи):
	NetMenager.айпи = айпи

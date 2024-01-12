class_name Сеть extends Node
## Основа сетевого обмена в этой игре.
##
## Пока что больше нет другого описания
##
## @experimental
signal начало_игры
var мой_логин
var мой_id
var peer
var айпи = "127.0.0.1"
var порт:int = 553
var игроки_лобби: Dictionary
func _ready():
	multiplayer.peer_connected.connect(игрок_подключился)
	multiplayer.peer_disconnected.connect(игрок_отключился)
	multiplayer.connected_to_server.connect(связь_с_сервером)
	multiplayer.connection_failed.connect(обрыв_связи)
	
func игрок_подключился(id):
	pass
func игрок_отключился(id):
	pass
func связь_с_сервером():
	отсылка_информации_об_игроке.rpc_id(1,мой_id, мой_логин)
	
	pass
func обрыв_связи():
	pass

@rpc("any_peer")
func отсылка_информации_об_игроке(id, логин):
	if !игроки_лобби.has(id):
		игроки_лобби[id] = {
			"логин": логин,
		}
	if multiplayer.is_server():
		for игрок in игроки_лобби:
			отсылка_информации_об_игроке.rpc(игрок, игроки_лобби[игрок].логин)
	print(игроки_лобби)
	pass

func создание_лобби(тип_игры = "стандарт"):
	peer = ENetMultiplayerPeer.new()
	var хост = peer.create_server(порт,2)
	if хост != OK:
		print("Ошибка: ", хост)
		return
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	мой_id = multiplayer.get_unique_id()
	отсылка_информации_об_игроке(мой_id, мой_логин)
	print(мой_id," " ,мой_логин)
	pass

func зайти_в_лобби():
	peer = ENetMultiplayerPeer.new()
	var клиент = peer.create_client(айпи, порт)
	peer.get_host().compress(ENetConnection.COMPRESS_RANGE_CODER)
	multiplayer.set_multiplayer_peer(peer)
	мой_id = multiplayer.get_unique_id()
	print(мой_id," " ,мой_логин)
@rpc("any_peer", "call_local")
func начать_игру():
	var матч = get_tree().current_scene.игра.instantiate()
	get_tree().current_scene.add_child(матч)
	начало_игры.emit()
	pass

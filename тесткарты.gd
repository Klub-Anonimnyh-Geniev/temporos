extends Node
class_name ТЕСТ

var TEST: PackedScene = preload("res://Карта3D.tscn")

func _init():
	var a = TEST.instantiate()
	add_child(a)

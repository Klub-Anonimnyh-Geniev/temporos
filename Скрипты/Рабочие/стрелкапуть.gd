extends Path3D
class_name УказательВыбора
var актор: Карта
var работать = false
@onready var каст = $RayCast3D
# Called when the node enters the scene tree for the first time.
var цель
func готовность():
	set_curve(Curve3D.new())
	curve.add_point(Vector3(актор.маркер.global_position),Vector3(0,.5,0),Vector3(0,0,0), 0)
	curve.add_point(Vector3(0,0,0),Vector3(0,.5,0),Vector3(0,0,0), 1)
	
	каст.target_position = Vector3(0,-1,0)
	работать = true
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if работать: 
		
		curve.set_point_position(1,Мышь3D(актор.маркер.global_position.y))
		каст.position = curve.get_point_position(1)
		if каст.is_colliding():
			цель = каст.get_collider().get_parent()
		else: цель = null
		
	pass


func Мышь3D(цель) -> Vector3:
	var камера: Camera3D = get_tree().current_scene.find_child("КАМЕРА", true, false)
	var мышь = get_viewport().get_mouse_position()
	return камера.project_position(мышь, камера.global_position.y-цель)
	

extends Spatial


onready var outline_node = $CardMesh/OutlineMesh


func _on_KinematicBody_mouse_entered():
	outline_node.show()

func _on_KinematicBody_mouse_exited():
	outline_node.hide()

func _on_KinematicBody_input_event(camera, event, click_position, click_normal, shape_idx):
	print(camera, " | " , event, " | ", click_position, " | ", click_normal)

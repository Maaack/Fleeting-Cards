extends Spatial


class_name Card

signal mouse_over
signal focus
signal unfocus
signal drag
signal drop

onready var outline_node = $CardMesh/OutlineMesh
onready var body_node = $KinematicBody

var focused: bool = false
var dragging: bool = false

func _on_KinematicBody_mouse_entered():
	focus()

func _on_KinematicBody_mouse_exited():
	unfocus()

func _on_KinematicBody_input_event(camera, event, click_position, click_normal, shape_idx):
	emit_signal("mouse_over", self, camera, event, click_position, click_normal, shape_idx)
	if event is InputEventMouseButton:
		if event.pressed:
			drag()
		else:
			drop()

func focus():
	focused = true
	outline_node.show()
	emit_signal('focus', self)

func unfocus():
	focused = false
	outline_node.hide()
	emit_signal('unfocus', self)

func drag():
	dragging = true
	body_node.input_ray_pickable = false
	emit_signal('drag', self)

func drop():
	dragging = false
	body_node.input_ray_pickable = true
	emit_signal('drop', self)

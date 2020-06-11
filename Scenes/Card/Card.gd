extends Spatial


class_name Card

signal mouse_over
signal focus
signal unfocus
signal drag
signal drop

onready var outline_node = $CardMesh/OutlineMesh
onready var body_node = $KinematicBody
onready var tween_node = $Tween

var focused: bool = false
var dragging: bool = false
var flipped: bool = false
var initial_rotation:Vector3

func ready():
	initial_rotation = rotation

func _on_KinematicBody_mouse_entered():
	focus()

func _on_KinematicBody_mouse_exited():
	unfocus()

func _on_KinematicBody_input_event(camera, event, click_position, click_normal, shape_idx):
	emit_signal("mouse_over", self, camera, event, click_position, click_normal, shape_idx)
	if event is InputEventMouseButton:
		if event.button_index == 1:
			if event.pressed:
				drag()
				if event.doubleclick:
					flip()
			else: 
				drop()
		if event.button_index == 2:
			if event.pressed:
				flip()

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

func flip():
	if flipped:
		tween_node.interpolate_property(self, "rotation", rotation, initial_rotation, get_flip_time())
	else:
		var flipped_rotation = initial_rotation
		flipped_rotation.z += PI
		tween_node.interpolate_property(self, "rotation", rotation, flipped_rotation, get_flip_time())
	flipped = !(flipped)
	tween_node.start()

func get_flip_time():
	return 0.25

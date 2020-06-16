tool
extends Spatial


class_name Card

signal mouse_over
signal focus
signal unfocus
signal drag
signal drop

enum CARD_FACES{CARD_BACK, CARD_FRONT, CARD_RIM}

onready var outline_node = $OutlineMesh
onready var body_node = $KinematicBody
onready var tween_node = $Tween
onready var card_mesh = $Card/CardMesh

export(StreamTexture) var card_front_texture : StreamTexture setget set_card_front_texture

var empty_card_front_texture = preload("res://Assets/Originals/Images/CardFront_Empty.png")
var focused: bool = false
var dragging: bool = false
var flipped: bool = false
var initial_rotation:Vector3

func _ready():
	initial_rotation = rotation
	_update_card_front_texture()

func set_card_front_texture(image:StreamTexture):
	card_front_texture = image
	_update_card_front_texture()

func _update_card_front_texture():
	if not is_instance_valid($Card/CardMesh):
		return
	if not is_instance_valid(card_front_texture):
		card_front_texture = empty_card_front_texture
	var mesh = $Card/CardMesh.mesh.duplicate()
	var material = mesh.surface_get_material(CARD_FACES.CARD_FRONT)
	material = material.duplicate()
	if material is SpatialMaterial:
		material.albedo_texture = card_front_texture
	mesh.surface_set_material(CARD_FACES.CARD_FRONT, material)
	$Card/CardMesh.mesh = mesh
	

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

tool
extends AbstractCard


class_name Card

signal mouse_over
signal focus
signal unfocus
signal drag
signal drop
signal spawn_card
signal move_complete

enum CardFaces{CARD_BACK, CARD_FRONT, CARD_RIM}

onready var outline_node = $OutlineMesh
onready var body_node = $KinematicBody
onready var tween_node = $Tween
onready var card_mesh = $Card/CardMesh
onready var animation_node = $AnimationPlayer
onready var stack_center_position = $Stack/StackCenter
onready var stack_right_position = $Stack/StackRight
onready var stack_left_position = $Stack/StackLeft
onready var stack_bottom_position = $Stack/StackBottom

export(Resource) var init_card_settings : Resource setget set_init_card_settings

var card_settings : CardSettings
var empty_card_front_texture = preload("res://Assets/Originals/Images/CardFronts/CardFront_Empty.png")
var initialized: bool = false
var burned: bool = false 
var focused: bool = false
var dragging: bool = false
var flipped: bool = false
var initial_rotation:Vector3

func _to_string():
	if card_settings:
		return card_settings.title
	else:
		return "Card %d" % [get_instance_id()]

func _ready():
	_update_card()

func init_turn():
	initialized = true
	initial_rotation = rotation

func set_init_card_settings(value:CardSettings):
	init_card_settings = value
	_apply_init_settings()

func _apply_init_settings():
	if init_card_settings is CardSettings:
		card_settings = init_card_settings.duplicate()
		_update_card()

func _update_card():
	if card_settings == null:
		return
	_update_card_title()
	_update_card_description()
	_update_card_front_texture()
	_update_card_from_start()
	_update_card_to_end()

func _update_card_title():
	if not is_instance_valid($Viewport/CardFrontContents/Title):
		return
	if card_settings.title == null:
		return
	$Viewport/CardFrontContents/Title.text = card_settings.title

func _update_card_description():
	if not is_instance_valid($Viewport/CardFrontContents/Description):
		return
	if card_settings.description == null:
		return
	$Viewport/CardFrontContents/Description.text = card_settings.description

func _update_card_from_start():
	if not is_instance_valid($Viewport/CardFrontContents/FromStart):
		return
	if not card_settings.counting_from_start:
		$Viewport/CardFrontContents/FromStart.hide()
		return
	$Viewport/CardFrontContents/FromStart.show()
	$Viewport/CardFrontContents/FromStart.text = str(card_settings.from_start)

func _update_card_to_end():
	if not is_instance_valid($Viewport/CardFrontContents/ToEnd):
		return
	if not card_settings.counting_to_end:
		$Viewport/CardFrontContents/ToEnd.hide()
		return
	$Viewport/CardFrontContents/ToEnd.show()
	$Viewport/CardFrontContents/ToEnd.text = str(card_settings.to_end)

func _update_card_front_texture():
	if not is_instance_valid($Card/CardMesh):
		return
	if not is_instance_valid(card_settings.front_texture):
		card_settings.front_texture = empty_card_front_texture
	var material = $Card/CardMesh.mesh.surface_get_material(CardFaces.CARD_FRONT)
	material = material.duplicate()
	if material is SpatialMaterial:
		material.albedo_texture = card_settings.front_texture
	$Card/CardMesh.set_surface_material(CardFaces.CARD_FRONT, material)

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
			else: 
				drop()
		if event.button_index == 2:
			if event.pressed:
				flip()

func focus():
	_focus()
	emit_signal('focus', self)

func _focus():
	focused = true
	if not is_instance_valid($OutlineMesh):
		return
	$OutlineMesh.show()

func unfocus():
	_unfocus()
	emit_signal('unfocus', self)

func _unfocus():
	focused = false
	if not is_instance_valid($OutlineMesh):
		return
	$OutlineMesh.hide()

func highlight_interaction():
	$HighlightInteractionMesh.show()

func unhighlight_interaction():
	$HighlightInteractionMesh.hide()

func drag():
	_drag()
	emit_signal('drag', self)

func _drag():
	dragging = true
	body_node.input_ray_pickable = false

func drop():
	_drop()
	emit_signal('drop', self)

func _drop():
	dragging = false
	body_node.input_ray_pickable = true

func move(new_translation:Vector3):
	if is_instance_valid(tween_node):
		if tween_node.is_active():
			tween_node.seek(_get_tween_time())
		if translation.distance_to(new_translation) > 0.1:
			tween_node.interpolate_property(self, "translation", translation, new_translation, _get_tween_time())
			tween_node.start()
			yield(tween_node, "tween_all_completed")
	translation = new_translation
	emit_signal("move_complete", self)

func _get_tween_time():
	return 0.1

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

func advance_turn():
	if card_settings == null:
		return
	card_settings.from_start += 1
	card_settings.to_end -= 1
	_update_card_from_start()
	_update_card_to_end()
	if card_settings.counting_to_end and card_settings.to_end <= 0:
		if is_active():
			count_reached_end()

func get_over_card_relative_translation(_click_position:Vector3):
	if not is_instance_valid($Stack/StackBottom):
		return
	return $Stack/StackBottom.translation

func get_over_card_translation(click_position:Vector3=Vector3()):
	return translation + get_over_card_relative_translation(click_position)

func burn():
	if burned:
		return
	burned = true
	if is_instance_valid(animation_node):
		animation_node.play("Burn")
		yield(animation_node, "animation_finished")
	queue_free()

func is_burned():
	return burned

func is_active():
	return initialized and not burned

func is_in_groups(group_names:Array):
	for group_name in group_names:
		if not is_in_group(group_name):
			return false
	return true

func spawn_card(card_scene:PackedScene):
	var card_instance = card_scene.instance()
	emit_signal("spawn_card", card_instance, get_over_card_translation())
	return card_instance

func count_reached_end():
	burn()

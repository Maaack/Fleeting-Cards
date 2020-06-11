extends Spatial


const DEFAULT_RAY_LENGTH = 1024
const VECTOR_3_MASK = Vector3(1.0, 0.0, 1.0)
const VECTOR_3_OFFSET = Vector3(0.0, 2.0, 0.0)

onready var camera_node = $Camera
onready var table_node = $Table

var dragging : Card
var hovering: Spatial

func _physics_process(_delta):
	pass

func _input(event):
	if event is InputEventMouseButton and not event.pressed and event.button_index == 1:
		if is_instance_valid(dragging):
			dragging.drop()

func _ready():
	for child in get_children():
		if child is Card:
			child.connect("drag", self, "_on_Card_drag")
			child.connect("drop", self, "_on_Card_drop")
			child.connect("mouse_over", self, "_on_Card_mouse_over")

func _on_Card_drag(card:Card):
	if is_instance_valid(card):
		dragging = card

func _on_Card_drop(card:Card):
	if is_instance_valid(dragging):
		var final_translation:Vector3 = Vector3()
		if hovering is Table:
			final_translation = dragging.translation * VECTOR_3_MASK
		if hovering is Card:
			final_translation = hovering.translation + Vector3(0.0, 0.1, 0.0)
		dragging.tween_node.interpolate_property(dragging, "translation", dragging.translation, final_translation, _get_tween_time())
		dragging.tween_node.start()
		dragging = null

func _on_Card_mouse_over(card:Card, camera, event, click_position, click_normal, shape_idx):
	_hover_over(card)

func _on_Table_mouse_over(table:Table, camera, event, click_position, click_normal, shape_idx):
	_hover_over(table, click_position)

func _hover_over(spatial:Spatial, click_position:Vector3 = Vector3()):
	hovering = spatial
	if is_instance_valid(dragging):
		var final_translation : Vector3 = spatial.translation + click_position
		final_translation *= VECTOR_3_MASK
		final_translation += VECTOR_3_OFFSET
		if dragging.translation.distance_to(final_translation) > 0.5:
			dragging.tween_node.interpolate_property(dragging, "translation", dragging.translation, final_translation, _get_tween_time())
			dragging.tween_node.start()
		else:
			dragging.translation = final_translation

func _get_tween_time():
	return 0.1

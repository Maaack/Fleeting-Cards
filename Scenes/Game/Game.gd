extends Spatial


const DEFAULT_RAY_LENGTH = 1024
const VECTOR_3_MASK = Vector3(1.0, 0.0, 1.0)
const VECTOR_3_OFFSET = Vector3(0.0, 2.0, 0.0)
const VECTOR_3_SEPARATION = Vector3(0.0, 0.03, 0.0)

onready var camera_node = $Camera
onready var table_node = $Table
onready var animate_camera_node = $Camera/AnimationPlayer

var dragging : Card
var hovering: Spatial
var game_turn: int = 0

func _input(event):
	if event is InputEventMouseButton and not event.pressed:
		match event.button_index:
			BUTTON_LEFT:
				if is_instance_valid(dragging):
					dragging.drop()
			BUTTON_WHEEL_UP:
				zoom_in()
			BUTTON_WHEEL_DOWN:
				zoom_out()

func _ready():
	for child in get_children():
		if child is Card:
			child.connect("drag", self, "_on_Card_drag")
			child.connect("drop", self, "_on_Card_drop")
			child.connect("mouse_over", self, "_on_Card_mouse_over")

func _on_Card_drag(card:Card):
	if dragging is Card:
		dragging.drop()
	if is_instance_valid(card):
		dragging = card

func _on_Card_drop(card:Card):
	if is_instance_valid(dragging):
		var final_translation:Vector3 = Vector3()
		if hovering is Table:
			final_translation = dragging.translation * VECTOR_3_MASK
		if hovering is Card:
			final_translation = hovering.stack_card(dragging)
		dragging.move(final_translation)
		dragging = null

func _on_Card_mouse_over(card:Card, camera, event, click_position, click_normal, shape_idx):
	_hover_over(card)

func _on_Table_mouse_over(table:Table, camera, event, click_position, click_normal, shape_idx):
	_hover_over(table, click_position)

func _hover_over(spatial:Spatial, click_position:Vector3 = Vector3()):
	hovering = spatial
	if is_instance_valid(dragging):
		var final_translation : Vector3
		if hovering is Card:
			final_translation = hovering.get_over_card_translation(click_position)
		else:
			final_translation = spatial.translation + click_position
		final_translation *= VECTOR_3_MASK
		final_translation += VECTOR_3_OFFSET
		dragging.move(final_translation)

func _get_tween_time():
	return 0.1

func zoom_out():
	animate_camera_node.step(-0.25)

func zoom_in():
	animate_camera_node.step(0.25)

func advance_turn():
	game_turn += 1
	print("Turn #%d" % game_turn)
	for child in get_children():
		if child is Card:
			child.advance_turn()

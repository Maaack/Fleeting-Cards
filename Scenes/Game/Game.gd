extends Spatial


const DEFAULT_RAY_LENGTH = 1024
const VECTOR_3_Y_MASK = Vector3(1.0, 0.0, 1.0)

onready var camera_node = $Camera
onready var table_node = $Table

export var card_drag_height: float = 2.0

var dragging : Card

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



func _on_Card_focus(card:Card):
	pass # Replace with function body.


func _on_Card_mouse_over(camera, event, click_position, click_normal, shape_idx):
	pass # Replace with function body.


func _on_Card_drag(card:Card):
	if is_instance_valid(card):
		dragging = card

func _on_Card_drop(card:Card):
	if is_instance_valid(dragging):
		dragging.translation.y = table_node.translation.y
		dragging = null

func _on_Table_mouse_over(table:Table, camera, event, click_position, click_normal, shape_idx):
	if is_instance_valid(dragging):
		var final_translation : Vector3
		final_translation = (click_position + table.translation) * VECTOR_3_Y_MASK
		final_translation.y = card_drag_height
		dragging.translation = final_translation

extends Spatial


const VECTOR_3_MASK = Vector3(1.0, 0.0, 1.0)
const VECTOR_3_OFFSET = Vector3(0.0, 1.5, 0.0)
const CONSUMER = 'CONSUMER'
const INITIATIVE = 'INITIATIVE'

onready var camera_pan_node = $CameraPan
onready var camera_node = $CameraPan/Camera
onready var animate_camera_node = $CameraPan/Camera/AnimationPlayer
onready var table_node = $Table

var dragging : AbstractCard
var hovering : Spatial
var game_turn : int = 0

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
		if child is AbstractCard:
			_init_card_turn(child)

func _post_card_instancing(card_instance):
	_init_card_turn(card_instance)

func _init_card_turn(card_instance):
	_connect_card_signals(card_instance)
	card_instance.init_turn()

func _connect_card_signals(card_instance):
	card_instance.connect("drag", self, "_on_Card_drag")
	card_instance.connect("drop", self, "_on_Card_drop")
	card_instance.connect("focus", self, "_on_Card_focus")
	card_instance.connect("unfocus", self, "_on_Card_unfocus")
	card_instance.connect("mouse_over", self, "_on_Card_mouse_over")
	card_instance.connect("spawn_card", self, "_on_Card_spawn_card")

func _on_Card_drag(card:AbstractCard):
	if dragging is AbstractCard:
		dragging.drop()
	if is_instance_valid(card):
		dragging = card
		_highlight_consumer_cards(card)

func _on_Card_drop(card:AbstractCard):
	if is_instance_valid(dragging):
		var final_translation:Vector3 = Vector3()
		if hovering is Table:
			final_translation = dragging.translation * VECTOR_3_MASK
		if hovering is AbstractCard:
			final_translation = hovering.stack_card(dragging)
		dragging.move(final_translation)
		dragging = null
		_unhighlight_consumer_cards()

func _on_Card_mouse_over(card:AbstractCard, camera, event, click_position, click_normal, shape_idx):
	_hover_over(card)

func _on_Card_focus(card:AbstractCard):
	_highlight_consumer_cards(card)

func _on_Card_unfocus(card:AbstractCard):
	if not is_instance_valid(dragging):
		_unhighlight_consumer_cards()

func _on_Card_spawn_card(card_instance:Spatial, spawn_translation):
	add_child(card_instance)
	_post_card_instancing(card_instance)
	card_instance.translation = spawn_translation

func _on_Table_mouse_over(table:Table, camera, event, click_position, click_normal, shape_idx):
	_hover_over(table, click_position)

func _hover_over(spatial:Spatial, click_position:Vector3 = Vector3()):
	hovering = spatial
	if is_instance_valid(dragging):
		var final_translation : Vector3
		if hovering is AbstractCard:
			final_translation = hovering.get_over_card_translation(click_position)
		else:
			final_translation = spatial.translation + click_position
		final_translation *= VECTOR_3_MASK
		final_translation += VECTOR_3_OFFSET
		dragging.move(final_translation)

func highlight_initiative_cards():
	for child in get_children():
		if child is Card and child.is_in_group(INITIATIVE):
			child.highlight_interaction()

func unhighlight_initiative_cards():
	for child in get_children():
		if child is Card and child.is_in_group(INITIATIVE):
			child.unhighlight_interaction()

func _highlight_consumer_cards(card:AbstractCard):
	for child in get_children():
		if child is ConsumerCard:
			child.highlight_matching_consumer(card)

func _unhighlight_consumer_cards():
	for child in get_children():
		if child is ConsumerCard:
			child.unhighlight_consumer()

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
		if child is AbstractCard:
			child.advance_turn()

tool
extends StackableCard


class_name ConsumerCard

const SLIDE_DOWN_ANIMATION = "SlideDown"
const SLIDE_UP_ANIMATION = "SlideUp"

onready var consumer_node = $Viewport/CardFrontContents/Consumes/ConsumesCardPanel
onready var consumer_animation_node = $Viewport/CardFrontContents/Consumes/AnimationPlayer
onready var consumer_highlight_mesh = $HighlightConsumerMesh

var consumes : CardCount

func _ready():
	_update_consumes()

func _update_consumes_panel():
	consumer_node.show()
	consumer_node.add_card_count(consumes)

func _update_consumes():
	if card_settings is ConsumerCardSettings:
		if card_settings.consumes != null:
			consumes = card_settings.consumes.duplicate()
			_update_consumes_panel()

func _highlight_consumer():
	consumer_highlight_mesh.show()

func highlight_matching_consumer(matching_card:AbstractCard):
	if matching_card.is_in_groups(consumes.groups):
		_highlight_consumer()

func unhighlight_consumer():
	consumer_highlight_mesh.hide()

func _highlight_interactable_cards():
	var parent = get_parent()
	for child in parent.get_children():
		if child is Card and child.is_in_groups(consumes):
			child.highlight_interaction()

func _unhighlight_interactable_cards():
	var parent = get_parent()
	for child in parent.get_children():
		if child is Card:
			child.unhighlight_interaction()

func focus():
	consumer_animation_node.play(SLIDE_DOWN_ANIMATION)
	return .focus()

func unfocus():
	.unfocus()
	hide_requirements()

func drop():
	.drop()
	hide_requirements()

func _show_requirements():
	consumer_animation_node.play(SLIDE_DOWN_ANIMATION)

func _hide_requirements():
	consumer_animation_node.play_backwards(SLIDE_DOWN_ANIMATION)

func show_requirements():
	_show_requirements()

func hide_requirements():
	if not dragging and not focused:
		_hide_requirements()

func stack_card(to_stack:AbstractCard):
	if to_stack.is_in_groups(consumes.groups) and not to_stack.is_burned():
		_consume_card(to_stack)
		return get_over_card_translation()
	return .stack_card(to_stack)

func _consume_card(required_card:AbstractCard):
	consumes.quantity -= 1
	required_card.burn()

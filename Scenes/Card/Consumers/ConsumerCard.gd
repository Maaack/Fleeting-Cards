tool
extends StackableCardNew


class_name ConsumerCard

const SLIDE_DOWN_ANIMATION = "SlideDown"
const SLIDE_UP_ANIMATION = "SlideUp"

onready var consumer_node = $Viewport/CardFrontContents/Consumes/ConsumesCardPanel
onready var consumer_animation_node = $Viewport/CardFrontContents/Consumes/AnimationPlayer

var consumes : CardCount

func _ready():
	_update_consumes_panel()

func _update_consumes_panel():
	if card_settings is ConsumerCardSettings:
		if card_settings.consumes != null:
			consumes = card_settings.consumes.duplicate()
			consumer_node.show()
			consumer_node.add_card_count(consumes)

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
	if to_stack.is_in_groups(consumes.groups):
		_consume_card(to_stack)
		return get_over_card_translation()
	return .stack_card(to_stack)

func _consume_card(required_card:AbstractCard):
	consumes.quantity -= 1
	required_card.burn()

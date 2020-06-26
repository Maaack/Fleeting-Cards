tool
extends StackableCard


signal spawn_card

const SLIDE_DOWN_ANIMATION = "SlideDown"
const SLIDE_UP_ANIMATION = "SlideUp"

onready var requirements_node = $Viewport/CardFrontContents/Requirements/RequirementCardPanel
onready var requirements_animation_node = $Viewport/CardFrontContents/Requirements/AnimationPlayer

export(Array, Resource) var init_requirements

var requirements : Array = []

func _ready():
	requirements_node.show()
	for init_requirement in init_requirements:
		var requirement = init_requirement.duplicate()
		requirements.append(requirement)
		requirements_node.add_requirement(requirement)

func advance_turn():
	var advance_return = .advance_turn()
	if card_to_end <= 0:
		remove_self()
	return advance_return

func focus():
	requirements_animation_node.play(SLIDE_DOWN_ANIMATION)
	return .focus()

func unfocus():
	.unfocus()
	hide_requirements()

func drop():
	.drop()
	hide_requirements()

func _show_requirements():
	requirements_animation_node.play(SLIDE_DOWN_ANIMATION)

func _hide_requirements():
	requirements_animation_node.play_backwards(SLIDE_DOWN_ANIMATION)

func show_requirements():
	_show_requirements()

func hide_requirements():
	if not dragging and not focused:
		_hide_requirements()

func stack_card(to_stack:Card):
	for requirement in requirements:
		if to_stack.is_in_group(requirement.card_group):
			requirement.card_quantity -= 1
			to_stack.remove_self()
			return get_over_card_translation()
	return .stack_card(to_stack)

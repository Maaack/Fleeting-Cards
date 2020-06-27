tool
extends StackableCard


class_name MomentCard

signal spawn_card

const SLIDE_DOWN_ANIMATION = "SlideDown"
const SLIDE_UP_ANIMATION = "SlideUp"

onready var requirements_node = $Viewport/CardFrontContents/Requirements/RequirementCardPanel
onready var requirements_animation_node = $Viewport/CardFrontContents/Requirements/AnimationPlayer

export(Array, Resource) var init_requirements
export(Array, Resource) var init_rewards
export(Array, Resource) var init_penalties

var requirements : Array = []
var rewards : Array = []
var penalties : Array = []

func _ready():
	requirements_node.show()
	_update_requirements()
	_update_rewards()
	_update_penalties()

func _update_requirements():
	for init_requirement in init_requirements:
		var requirement = init_requirement.duplicate()
		requirements.append(requirement)
		requirements_node.add_requirement(requirement)

func _update_rewards():
	for init_reward in init_rewards:
		var reward = init_reward.duplicate()
		rewards.append(reward)

func _update_penalties():
	for init_penalty in init_penalties:
		var penalty = init_penalty.duplicate()
		penalties.append(penalty)

func advance_turn():
	var advance_return = .advance_turn()
	active_penalty()
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
			activate_reward()
			return get_over_card_translation()
	return .stack_card(to_stack)

func check_requirements():
	if destroyed:
		return false
	for requirement in requirements:
		if requirement.card_quantity > 0:
			return false
	return true

func _activate_reward():
	for reward in rewards:
		var card_instance
		if reward is Reward:
			card_instance = reward.card_scene.instance()
		elif reward is PackedScene:
			card_instance = reward.instance()
		emit_signal("spawn_card", card_instance, stack_card(card_instance))

func activate_reward():
	if check_requirements():
		_activate_reward()
		remove_self()

func _activate_penalty():
	for penalty in penalties:
		var card_instance
		if penalty is Reward:
			card_instance = penalty.card_scene.instance()
		elif penalty is PackedScene:
			card_instance = penalty.instance()
		emit_signal("spawn_card", card_instance, stack_card(card_instance))

func active_penalty():
	if card_to_end <= 0 and not destroyed:
		_activate_penalty()
		remove_self()

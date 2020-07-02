tool
extends ConsumerCard


class_name FalloutCard

var rewards : Array = []
var penalties : Array = []

func _ready():
	_update_rewards()
	_update_penalties()

func _update_rewards():
	if card_settings is FalloutCardSettings:
		for init_reward in card_settings.rewards:
			var reward = init_reward.duplicate()
			rewards.append(reward)

func _update_penalties():
	if card_settings is FalloutCardSettings:
		for init_penalty in card_settings.penalties:
			var penalty = init_penalty.duplicate()
			penalties.append(penalty)

func advance_turn():
	var advance_return = .advance_turn()
	active_penalty()
	return advance_return

func check_requirements():
	if burned:
		return false
	if consumes.quantity > 0:
		return false
	return true

func _activate_reward():
	for reward in rewards:
		var card_instance
		if reward is Reward:
			spawn_card(reward.card_scene)
		elif reward is PackedScene:
			spawn_card(reward)

func activate_reward():
	if check_requirements():
		_activate_reward()
		burn()

func _activate_penalty():
	for penalty in penalties:
		var card_instance
		if penalty is Reward:
			card_instance = penalty.card_scene.instance()
		elif penalty is PackedScene:
			card_instance = penalty.instance()
		emit_signal("spawn_card", card_instance, stack_card(card_instance))

func active_penalty():
	if card_settings.to_end <= 0 and not burned:
		_activate_penalty()
		burn()

func _consume_card(required_card:Card):
	var result = ._consume_card(required_card)
	if result is GDScriptFunctionState:
		yield(result, "completed")
	activate_reward()

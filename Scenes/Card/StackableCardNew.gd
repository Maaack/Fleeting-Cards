tool
extends CardNew


class_name StackableCardNew

var card_above : AbstractCard
var card_below : AbstractCard

func _focus():
	._focus()
	if is_instance_valid(card_above) and card_above is AbstractCard:
		card_above._focus()

func _unfocus():
	._unfocus()
	if is_instance_valid(card_above) and card_above is AbstractCard:
		card_above._unfocus()

func drag():
	unstack_card()
	.drag()

func _drag():
	._drag()
	if is_instance_valid(card_above) and card_above is AbstractCard:
		card_above._drag()

func _drop():
	._drop()
	if is_instance_valid(card_above) and card_above is AbstractCard:
		card_above._drop()

func stack_card(to_stack:AbstractCard):
	if is_instance_valid(card_above) and card_above is AbstractCard:
		return card_above.stack_card(to_stack)
	var final_translation = get_over_card_translation(to_stack.translation)
	if not is_instance_valid(card_above):
		card_above = to_stack
		to_stack.card_below = self
	return final_translation

func unstack_card():
	if is_instance_valid(card_below) and card_below is AbstractCard:
		card_below.card_above = null
		card_below = null

func move(new_translation:Vector3):
	.move(new_translation)
	if is_instance_valid(card_above) and card_above is AbstractCard:
		var stacked_translation = new_translation + get_over_card_relative_translation(new_translation)
		card_above.move(stacked_translation)

func get_over_card_translation(click_position:Vector3=Vector3()):
	if is_instance_valid(card_above) and card_above is AbstractCard:
		return card_above.get_over_card_translation(click_position)
	return .get_over_card_translation(click_position)

func burn():
	var old_card_above = card_above
	var old_card_below = card_below
	.burn()
	if is_instance_valid(tween_node) and tween_node.is_active():
		tween_node.seek(_get_tween_time())
	unstack_card()
	if is_instance_valid(old_card_above):
		old_card_above.unstack_card()
		old_card_above.move(translation)
		if is_instance_valid(old_card_below):
			old_card_below.stack_card(old_card_above)

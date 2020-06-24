tool
extends Card


class_name StackableCard

var card_above : Card
var card_below : Card

func _focus():
	._focus()
	if card_above is Card:
		card_above._focus()

func _unfocus():
	._unfocus()
	if card_above is Card:
		card_above._unfocus()

func drag():
	unstack_card()
	.drag()

func _drag():
	._drag()
	if card_above is Card:
		card_above._drag()

func _drop():
	._drop()
	if card_above is Card:
		card_above._drop()

func stack_card(to_stack:Card):
	if card_above is Card:
		return card_above.stack_card(to_stack)
	var final_translation = get_over_card_translation(to_stack.translation)
	if card_above == null:
		card_above = to_stack
		to_stack.card_below = self
	return final_translation

func unstack_card():
	if card_below is Card:
		card_below.card_above = null
		card_below = null

func move(new_translation:Vector3):
	.move(new_translation)
	if card_above is Card:
		var stacked_translation = new_translation + get_over_card_relative_translation(new_translation)
		card_above.move(stacked_translation)

func get_over_card_translation(click_position:Vector3=Vector3()):
	if card_above is Card:
		return card_above.get_over_card_translation(click_position)
	return .get_over_card_translation(click_position)

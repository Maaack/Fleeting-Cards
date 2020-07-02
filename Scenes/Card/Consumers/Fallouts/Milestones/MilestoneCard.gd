tool
extends FalloutCard


class_name MilestoneCard

func advance_turn():
	.advance_turn()
	_pull_cards(consumes)

func _pull_cards(matching:CardCount):
	var parent : Node = get_parent()
	for child in parent.get_children():
		if child is AbstractCard and child.is_in_groups(matching.groups) and child.is_active():
			stack_card(child)

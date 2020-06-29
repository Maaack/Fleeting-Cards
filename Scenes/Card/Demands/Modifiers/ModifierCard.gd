tool
extends DemandsCard


class_name ModifierCard

func advance_turn():
	.advance_turn()
	for requirement in requirements:
		_pull_cards(requirement)

func _pull_cards(demand:Requirement):
	var parent : Node = get_parent()
	for child in parent.get_children():
		if child is Card and child.is_in_groups(demand.card_groups):
			stack_card(child)

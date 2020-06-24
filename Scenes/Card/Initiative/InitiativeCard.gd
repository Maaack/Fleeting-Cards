tool
extends StackableCard


signal spawn_card


func advance_turn():
	var advance_return = .advance_turn()
	if card_to_end <= 0:
		remove_self()
	return advance_return


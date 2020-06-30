tool
extends StackableCardNew


signal spawn_card


func advance_turn():
	var advance_return = .advance_turn()
	if card_settings.to_end <= 0:
		burn()
	return advance_return


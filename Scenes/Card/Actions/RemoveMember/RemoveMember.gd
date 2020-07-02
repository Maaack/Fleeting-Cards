extends StackableCard


const MEMBER = 'MEMBER'
const YOU_THE_PLAYER = 'YOU_THE_PLAYER'

func init_turn():
	var member = get_valid_member()
	if member is AbstractCard:
		member.burn()
	burn()

func get_valid_member():
	var members : Array = []
	var parent : Node = get_parent()
	for child in parent.get_children():
		if child.is_in_group(MEMBER) and not child.is_in_group(YOU_THE_PLAYER):
			members.append(child)
	randomize()
	members.shuffle()
	return members.pop_front()

extends StackableCard


const CAUSE = 'CAUSE'
const GREATER_CAUSE = 'GREATER_CAUSE'

func init_turn():
	var member = get_valid_cause()
	if member is AbstractCard:
		member.burn()
	burn()

func get_valid_cause():
	var causes : Array = []
	var parent : Node = get_parent()
	for child in parent.get_children():
		if child.is_in_group(CAUSE) and not child.is_in_group(GREATER_CAUSE):
			causes.append(child)
	randomize()
	causes.shuffle()
	return causes.pop_front()

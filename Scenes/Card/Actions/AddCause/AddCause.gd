extends StackableCard


signal spawn_card

const CAUSE = 'CAUSE'
const GREATER_CAUSE = 'GREATER_CAUSE'

var cause_scene = load("res://Scenes/Card/Spawners/Causes/DefaultCauseCard.tscn")

func init_turn():
	var cause_instance = cause_scene.instance()
	emit_signal("spawn_card", cause_instance, stack_card(cause_instance))
	burn()

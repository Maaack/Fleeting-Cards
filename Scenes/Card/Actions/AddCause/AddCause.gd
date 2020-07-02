extends StackableCard


const CAUSE = 'CAUSE'
const GREATER_CAUSE = 'GREATER_CAUSE'

var cause_scene = load("res://Scenes/Card/Spawners/Causes/DefaultCauseCard.tscn")

func init_turn():
	spawn_card(cause_scene)
	burn()

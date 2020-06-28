tool
extends StackableCard


class_name MemberCard

signal spawn_card

var initiative_card_scene = preload("res://Scenes/Card/Initiative/InitiativeCard.tscn")

func advance_turn():
	var initiative_card_instance = initiative_card_scene.instance()
	emit_signal("spawn_card", initiative_card_instance, stack_card(initiative_card_instance))
	return .advance_turn()


extends NinePatchRect


onready var card_requirement_node = $MarginContainer/Control/CardRequirement


func add_card_count(value:CardCount):
	if is_instance_valid(value):
		card_requirement_node.card_count = value

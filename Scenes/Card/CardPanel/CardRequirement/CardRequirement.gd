extends HBoxContainer


onready var quantity_node = $QuantityLabel
onready var icon_node = $IconContainer/IconRect

var requirement : Requirement setget set_requirement

func _process(delta):
	if is_instance_valid(requirement):
		quantity_node.text = str(requirement.card_quantity)

func set_requirement(value:Requirement):
	requirement = value
	if is_instance_valid(requirement):
		quantity_node.text = str(requirement.card_quantity)
		icon_node.texture = requirement.card_icon

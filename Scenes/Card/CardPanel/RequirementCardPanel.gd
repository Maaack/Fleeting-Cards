extends NinePatchRect


onready var control_node = $MarginContainer/Control

var card_requirement_scene = preload("res://Scenes/Card/CardPanel/CardRequirement/CardRequirement.tscn")

func add_requirement(value:Requirement):
	if is_instance_valid(value):
		var card_requirement_instance = card_requirement_scene.instance()
		control_node.add_child(card_requirement_instance)
		card_requirement_instance.requirement = value

func add_card_count(value:CardCount):
	if is_instance_valid(value):
		var card_requirement_instance = card_requirement_scene.instance()
		control_node.add_child(card_requirement_instance)
		card_requirement_instance.card_count = value

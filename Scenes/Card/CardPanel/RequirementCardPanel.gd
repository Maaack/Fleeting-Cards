extends NinePatchRect


onready var list_node = $MarginContainer/Control/RequirementList

var card_requirement_scene = preload("res://Scenes/Card/CardPanel/CardRequirement/CardRequirement.tscn")

func add_requirement(value:Requirement):
	if is_instance_valid(value):
		var card_requirement_instance = card_requirement_scene.instance()
		list_node.add_child(card_requirement_instance)
		card_requirement_instance.requirement = value

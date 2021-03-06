extends HBoxContainer


onready var quantity_node = $QuantityLabel
onready var icon_node = $IconContainer/IconRect

var card_count : CardCount setget set_card_count

func _process(delta):
	if is_instance_valid(card_count):
		quantity_node.text = str(card_count.quantity)

func set_card_count(value:CardCount):
	card_count = value
	if is_instance_valid(card_count):
		quantity_node.text = str(card_count.quantity)
		icon_node.texture = card_count.icon

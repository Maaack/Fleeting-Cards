extends Resource


class_name CardCount

export(Array, String) var groups
export(Texture) var icon
export(int, 0, 1024) var quantity

func _to_string():
	return "%s (%d)" % [str(groups), quantity]

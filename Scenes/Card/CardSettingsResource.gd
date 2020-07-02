extends Resource


class_name CardSettings

export(Texture) var front_texture
export(String) var title
export(String, MULTILINE) var description
export(bool) var counting_from_start = false
export(bool) var counting_to_end = false
export(int,0,256) var from_start = null
export(int,0,256) var to_end = null

func _to_string():
	return title

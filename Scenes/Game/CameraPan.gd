extends Spatial


const UP_VECTOR = Vector3(0, 0, -0.1)
const DOWN_VECTOR = Vector3(0, 0, 0.1)
const LEFT_VECTOR = Vector3(-0.1, 0, 0)
const RIGHT_VECTOR = Vector3(0.1, 0, 0)
onready var tween_node = $Tween

export(float) var max_range = 5.0

var pan_to : Vector3

func _ready():
	pan_to = translation

func _get_tween_time():
	return 0.25

func _process(_delta):
	if Input.is_action_pressed("ui_up"):
		pan(UP_VECTOR)
	if Input.is_action_pressed("ui_down"):
		pan(DOWN_VECTOR)
	if Input.is_action_pressed("ui_left"):
		pan(LEFT_VECTOR)
	if Input.is_action_pressed("ui_right"):
		pan(RIGHT_VECTOR)


func pan(add_translation:Vector3):
	pan_to += add_translation
	var max_ratio = pan_to.length() / max_range
	if max_ratio > 1.0:
		pan_to /= max_ratio
	if is_instance_valid(tween_node):
		if translation.distance_to(pan_to) > 0.05:
			tween_node.interpolate_property(self, "translation", translation, pan_to, _get_tween_time())
			tween_node.start()
			return
	translation = pan_to

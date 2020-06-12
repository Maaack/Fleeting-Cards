extends AnimationPlayer


const ZOOM_ANIMATION = "Zoom"

func _ready():
	play(ZOOM_ANIMATION)
	stop(false)

func step(value:float):
	play()
	if value > 0 and value + current_animation_position < current_animation_length:
		advance(value)
	elif value < 0 and value + current_animation_position >= 0:
		advance(value)
	stop(false)

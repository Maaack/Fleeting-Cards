tool
extends StackableCard

const SLIDE_DOWN_ANIMATION = "SlideDown"
const SLIDE_UP_ANIMATION = "SlideUp"

onready var requirements_node = $Viewport/CardFrontContents/Requirements
onready var requirements_animation_node = $Viewport/CardFrontContents/Requirements/AnimationPlayer

signal spawn_card

func _ready():
	requirements_node.show()

func advance_turn():
	var advance_return = .advance_turn()
	if card_to_end <= 0:
		remove_self()
	return advance_return

func focus():
	requirements_animation_node.play(SLIDE_DOWN_ANIMATION)
	return .focus()

func unfocus():
	.unfocus()
	hide_requirements()

func drop():
	.drop()
	hide_requirements()

func _show_requirements():
	requirements_animation_node.play(SLIDE_DOWN_ANIMATION)

func _hide_requirements():
	requirements_animation_node.play_backwards(SLIDE_DOWN_ANIMATION)

func show_requirements():
	_show_requirements()

func hide_requirements():
	if not dragging and not focused:
		_hide_requirements()

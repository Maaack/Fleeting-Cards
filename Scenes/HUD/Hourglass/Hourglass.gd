extends Control


signal next_turn

const FLIP_ANIMATION = "Flip"

func _on_TextureButton_button_down():
	emit_signal("next_turn")
	if not is_instance_valid($AnimationPlayer):
		return
	$AnimationPlayer.play(FLIP_ANIMATION)

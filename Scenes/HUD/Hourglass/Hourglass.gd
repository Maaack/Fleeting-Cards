extends Control


signal next_turn
signal mouse_entered_button
signal mouse_exited_button

const FLIP_ANIMATION = "Flip"

func _on_TextureButton_button_down():
	emit_signal("next_turn")
	if not is_instance_valid($AnimationPlayer):
		return
	$AnimationPlayer.play(FLIP_ANIMATION)

func _on_TextureButton_mouse_entered():
	emit_signal("mouse_entered_button")


func _on_TextureButton_mouse_exited():
	emit_signal("mouse_exited_button")

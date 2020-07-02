extends Control


signal next_turn
signal focus_hourglass
signal unfocus_hourglass

func _on_Hourglass_next_turn():
	emit_signal("next_turn")

func _on_Hourglass_mouse_entered_button():
	emit_signal("focus_hourglass")

func _on_Hourglass_mouse_exited_button():
	emit_signal("unfocus_hourglass")

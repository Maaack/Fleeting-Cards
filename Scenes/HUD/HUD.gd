extends Control


signal next_turn

func _on_Hourglass_next_turn():
	emit_signal("next_turn")

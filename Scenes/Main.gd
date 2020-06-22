extends Control


func _on_HUD_next_turn():
	if not is_instance_valid($ViewportContainer/Viewport/Game):
		return
	$ViewportContainer/Viewport/Game.advance_turn()

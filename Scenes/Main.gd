extends Control


func _on_HUD_next_turn():
	if not is_instance_valid($ViewportContainer/Viewport/Game):
		return
	$ViewportContainer/Viewport/Game.advance_turn()

func _on_HUD_focus_hourglass():
	if not is_instance_valid($ViewportContainer/Viewport/Game):
		return
	$ViewportContainer/Viewport/Game.highlight_initiative_cards()

func _on_HUD_unfocus_hourglass():
	if not is_instance_valid($ViewportContainer/Viewport/Game):
		return
	$ViewportContainer/Viewport/Game.unhighlight_initiative_cards()

extends Spatial


class_name Table

signal mouse_over

func _on_Area_input_event(camera, event, click_position, click_normal, shape_idx):
	emit_signal("mouse_over", self, camera, event, click_position, click_normal, shape_idx)

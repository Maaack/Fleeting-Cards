extends Resource


class_name SpawnTimer

enum TimerSetting{REPEAT, ONCE}

export(int) var card_spawn_delay
export(TimerSetting) var spawn_timer_setting
export(PackedScene) var card_scene

func _to_string():
	return "TimerSetting: %d %d" % [card_spawn_delay, spawn_timer_setting] 

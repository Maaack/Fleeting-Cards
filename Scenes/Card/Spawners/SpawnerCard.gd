tool
extends StackableCard


class_name SpawnerCard

signal spawn_card

var spawn_timers : Array = []

func _ready():
	_update_spawn_timers()

func _update_spawn_timers():
	if card_settings is SpawnerCardSettings:
		for init_spawn_timer in card_settings.spawn_timers:
			var spawn_timer = init_spawn_timer.duplicate()
			spawn_timers.append(spawn_timer)

func advance_turn():
	.advance_turn()
	_check_spawn_timers()

func _check_spawn_timers():
	for spawn_timer in spawn_timers:
		if spawn_timer is SpawnTimer:
			match(spawn_timer.spawn_timer_setting):
				spawn_timer.TimerSetting.REPEAT:
					if card_settings.from_start % spawn_timer.card_spawn_delay == 0:
						var card_instance = spawn_timer.card_scene.instance()
						emit_signal("spawn_card", card_instance, stack_card(card_instance))
				spawn_timer.TimerSetting.ONCE:
					if card_settings.from_start == spawn_timer.card_spawn_delay:
						var card_instance = spawn_timer.card_scene.instance()
						emit_signal("spawn_card", card_instance, stack_card(card_instance))

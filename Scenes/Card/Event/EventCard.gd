tool
extends StackableCard


signal spawn_card

export(Array, Resource) var init_spawn_timers

var spawn_timers : Array = []

func _ready():
	_update_spawn_timers()

func _update_spawn_timers():
	for init_spawn_timer in init_spawn_timers:
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
					if card_from_start % spawn_timer.card_spawn_delay == 0:
						var card_instance = spawn_timer.card_scene.instance()
						emit_signal("spawn_card", card_instance, stack_card(card_instance))
				spawn_timer.TimerSetting.ONCE:
					if card_from_start == spawn_timer.card_spawn_delay:
						var card_instance = spawn_timer.card_scene.instance()
						emit_signal("spawn_card", card_instance, stack_card(card_instance))

tool
extends StackableCard


class_name AllianceCard

signal spawn_card

export(Array, Resource) var init_strength_spawn_timers
export(Array, Resource) var init_weakness_spawn_timers

var strength_spawn_timers : Array = []
var weakness_spawn_timers : Array = []
var strength_timer : int = 0
var weakness_timer : int = 0
var strength_increment : int = 0
var weakness_increment : int = 0

func _ready():
	_update_strength_spawn_timers()
	_update_weakness_spawn_timers()

func _update_strength_spawn_timers():
	for init_strength_spawn_timer in init_strength_spawn_timers:
		var strength_spawn_timer = init_strength_spawn_timer.duplicate()
		strength_spawn_timers.append(strength_spawn_timer)

func _update_weakness_spawn_timers():
	for init_weakness_spawn_timer in init_weakness_spawn_timers:
		var weakness_spawn_timer = init_weakness_spawn_timer.duplicate()
		weakness_spawn_timers.append(weakness_spawn_timer)

func advance_turn():
	.advance_turn()
	_update_timers()
	_spawn_modifications()

func get_all_members():
	var members : Array = []
	var parent : Node = get_parent()
	for child in parent.get_children():
		if child is MemberCard:
			members.append(child)
	return members

func _update_timers():
	strength_increment = 0
	weakness_increment = 0
	var members = get_all_members()
	if members.size() == 0:
		return
	strength_increment = max(0, members.size() - 1)
	weakness_increment = max(0, members.size() - 1)
	strength_timer += strength_increment
	weakness_timer += weakness_increment

func _spawn_from_array(timer:int, spawn_timers:Array):
	for spawn_timer in spawn_timers:
		if spawn_timer is SpawnTimer:
			if timer % spawn_timer.card_spawn_delay == 0:
				var card_instance = spawn_timer.card_scene.instance()
				emit_signal("spawn_card", card_instance, stack_card(card_instance))

func _can_spawn_strength():
	return strength_increment > 0

func _can_spawn_weakness():
	return weakness_increment > 0

func _spawn_modifications():
	if _can_spawn_strength():
		_spawn_from_array(strength_timer, strength_spawn_timers)
	if _can_spawn_weakness():
		_spawn_from_array(weakness_timer, weakness_spawn_timers)

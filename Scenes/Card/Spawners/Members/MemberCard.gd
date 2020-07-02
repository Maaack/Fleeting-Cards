tool
extends SpawnerCard


class_name MemberCard

const MEMBER = 'MEMBER'
const ALLIANCE = 'ALLIANCE'

var alliance_scene : PackedScene = preload("res://Scenes/Card/Alliance/BaseAllianceCard.tscn")

func init_turn():
	.init_turn()
	_create_alliance()

func _create_alliance():
	var parent : Node = get_parent()
	var member_count : int = 0
	var has_alliance : bool = false
	for child in parent.get_children():
		if child.is_in_group(MEMBER):
			member_count += 1
		if child.is_in_group(ALLIANCE):
			has_alliance = true
	if member_count > 1 and not has_alliance:
		var alliance_instance = alliance_scene.instance()
		emit_signal('spawn_card', alliance_instance, stack_card(alliance_instance))

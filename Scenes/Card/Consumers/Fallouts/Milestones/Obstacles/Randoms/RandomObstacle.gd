extends MilestoneCard



const MEMBER = 'LOSE_MEMBER'
const CAUSE = 'LOST_CAUSE'
const EVENT = 'EVENT'
const OPPORTUNITY = 'OPPORTUNITY'
const THREAT = 'THREAT'
const STRENGTH = 'STRENGTH'
const WEAKNESS = 'WEAKNESS'
const MEMBER_TITLE_TEXT = 'Apathy'
const CAUSE_TITLE_TEXT = 'Lost Cause'
const EVENT_TITLE_TEXT = 'Social Inertia'
const OPPORTUNITY_DESCRIPTION_TEXT = 'Missed opportunities provoke this obstacle.'
const THREAT_DESCRIPTION_TEXT = 'Escaped threats provoke this obstacle.'
const STRENGTH_DESCRIPTION_TEXT = 'Atrophied strengths provoke this obstacle.'
const WEAKNESS_DESCRIPTION_TEXT = 'Spurned weaknesses provoke this obstacle.'

export(Array, Resource) var random_consumes
export(Array, Resource) var random_rewards
export(Array, Resource) var random_penalties

func _ready():
	randomize()
	_randomize_settings()

func _randomize_settings():
	_update_random_consumes()
	_update_random_rewards()
	_update_random_penalties()

func _update_random_consumes():
	if random_consumes is Array and random_consumes.size() > 0:
		var local_consumes : Array = random_consumes.duplicate()
		local_consumes.shuffle()
		card_settings.consumes = local_consumes.pop_front()
		_update_consumes()
		_set_random_description(consumes.groups)

func _update_random_rewards():
	if random_rewards is Array and random_rewards.size() > 0:
		rewards = []
		var local_rewards : Array = random_rewards.duplicate()
		local_rewards.shuffle()
		var local_reward = local_rewards.pop_front()
		var local_reward_instance = local_reward.instance()
		_set_random_title(local_reward_instance.get_groups())
		card_settings.rewards = [local_reward]
		_update_rewards()

func _update_random_penalties():
	if random_penalties is Array and random_penalties.size() > 0:
		penalties = []
		var local_penalties : Array = random_penalties.duplicate()
		local_penalties.shuffle()
		var local_penalty = local_penalties.pop_front()
		card_settings.penalties = [local_penalty]
		_update_penalties()

func _set_random_title(groups:Array):
	var title_text : String
	if MEMBER in groups:
		title_text = MEMBER_TITLE_TEXT
	elif CAUSE in groups:
		title_text = CAUSE_TITLE_TEXT
	elif EVENT in groups:
		title_text = EVENT_TITLE_TEXT
	if title_text:
		card_settings.title = title_text
		_update_card_title()

func _set_random_description(groups:Array):
	var description_text : String
	if OPPORTUNITY in groups:
		description_text = OPPORTUNITY_DESCRIPTION_TEXT
	elif THREAT in groups:
		description_text = THREAT_DESCRIPTION_TEXT
	elif STRENGTH in groups:
		description_text = STRENGTH_DESCRIPTION_TEXT
	elif WEAKNESS in groups:
		description_text = WEAKNESS_DESCRIPTION_TEXT
	if description_text:
		card_settings.description = description_text
		_update_card_description()

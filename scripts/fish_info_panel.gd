extends TextureRect

@onready var fish_portrait = $MarginContainer/VBoxContainer/HBoxContainer/FishData/PortraitFrame/FishSprite
@onready var atk_value = $MarginContainer/VBoxContainer/HBoxContainer/FishData/TextureRect/VBoxContainer/AttackContainer/AttackLabel
@onready var def_value = $MarginContainer/VBoxContainer/HBoxContainer/FishData/TextureRect/VBoxContainer/DefenseContainer/DefenseLabel
@onready var spd_value = $MarginContainer/VBoxContainer/HBoxContainer/FishData/TextureRect/VBoxContainer/SpeedContainer/SpeedLabel
@onready var moves_labels = [
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move1/Label,
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move2/Label,
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move3/Label,
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move4/Label
]
@onready var move_containers = [
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move1,
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move2,
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move3,
	$MarginContainer/VBoxContainer/HBoxContainer/MovesContainer/Move4
]
@onready var ability_name = $MarginContainer/VBoxContainer/TextureRect/AbilityName
@onready var ability_desc = $MarginContainer/VBoxContainer/TextureRect/Label

func _ready():
	clear_info()

func update_fish_info(fish_data: Variant):
	var is_resource = fish_data is Resource
	
	if is_resource:
		if "sprite" in fish_data:
			fish_portrait.texture = fish_data.sprite
	else:
		if fish_data.has("icon"):
			fish_portrait.texture = fish_data.icon
		elif fish_data.has("portrait"):
			fish_portrait.texture = fish_data.portrait
		elif fish_data.has("sprite"):
			fish_portrait.texture = fish_data.sprite
	
	if is_resource:
		atk_value.text = str(fish_data.base_atk if "base_atk" in fish_data else 0)
		def_value.text = str(fish_data.base_def if "base_def" in fish_data else 0)
		spd_value.text = str(fish_data.base_spd if "base_spd" in fish_data else 0)
	else:
		if fish_data.has("stats"):
			atk_value.text = str(fish_data.stats.atk)
			def_value.text = str(fish_data.stats.def)
			spd_value.text = str(fish_data.stats.spd)
		else:
			atk_value.text = str(fish_data.get("atk", 0))
			def_value.text = str(fish_data.get("def", 0))
			spd_value.text = str(fish_data.get("spd", 0))
	
	var moves_array = []
	if is_resource and "moves" in fish_data:
		moves_array = fish_data.moves
	elif not is_resource and fish_data.has("moves"):
		moves_array = fish_data.moves
	
	for i in range(4):
		if i < moves_array.size():
			var move = moves_array[i]
			if move == null:
				move_containers[i].visible = false
				continue
			
			if move is String:
				moves_labels[i].text = move
			elif move is Dictionary:
				moves_labels[i].text = move.get("move_name", move.get("name", "???"))
			else:
				moves_labels[i].text = move.move_name if "move_name" in move else "???"
			move_containers[i].visible = true
		else:
			move_containers[i].visible = false
	
	var ability = null
	if is_resource:
		if "passive_ability" in fish_data:
			ability = {
				"name": fish_data.passive_ability,
				"description": fish_data.passive_description if "passive_description" in fish_data else ""
			}
	elif not is_resource and fish_data.has("ability"):
		ability = fish_data.ability
	
	if ability != null:
		if ability is Dictionary:
			ability_name.text = ability.get("name", "")
			ability_desc.text = ability.get("description", "")
		else:
			ability_name.text = ability.name if "name" in ability else ""
			ability_desc.text = ability.description if "description" in ability else ""
	else:
		ability_name.text = ""
		ability_desc.text = ""

func clear_info():
	fish_portrait.texture = null
	atk_value.text = "0"
	def_value.text = "0"
	spd_value.text = "0"
	ability_name.text = ""
	ability_desc.text = ""
	
	for container in move_containers:
		container.visible = false

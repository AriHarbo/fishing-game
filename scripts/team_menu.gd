extends Control

const FishSlotScene = preload("res://scenes/ui/fish_slot.tscn")

@onready var slots_container: VBoxContainer = $Background/MarginContainer/VBoxContainer
@onready var fish_info_panel = $FishInfoPanel as Control

var fish_slots: Array = []
const MAX_TEAM_SIZE = 4
var team_data: Array = []
var selected_index: int = 0

func _ready():
	create_slots()
	visible = false
	set_process_input(true)

func _input(event):
	if event.is_action_pressed("ui_team"):
		toggle_menu()
		get_viewport().set_input_as_handled()
	

func toggle_menu():
	visible = not visible
	
	if visible:
		update_team_display()
		if team_data.size() > 0:
			select_fish(0)

func create_slots():
	for child in slots_container.get_children():
		child.queue_free()
	
	fish_slots.clear()
	
	for i in range(MAX_TEAM_SIZE):
		var slot = FishSlotScene.instantiate()
		slot.slot_index = i
		slots_container.add_child(slot)
		fish_slots.append(slot)
		slot.slot_clicked.connect(_on_fish_slot_clicked)

func update_team_display():
	for i in range(MAX_TEAM_SIZE):
		if i < team_data.size():
			fish_slots[i].set_fish(team_data[i])
		else:
			fish_slots[i].clear_slot()

func select_fish(index: int):
	if index < 0 or index >= team_data.size():
		return
	
	if selected_index >= 0 and selected_index < fish_slots.size():
		fish_slots[selected_index].set_selected(false)
	
	selected_index = index
	fish_slots[selected_index].set_selected(true)
	fish_info_panel.update_fish_info(team_data[selected_index])

func _on_fish_slot_clicked(slot_index: int):
	select_fish(slot_index)

func add_fish_to_team(fish_data: FishData) -> bool:
	if team_data.size() < MAX_TEAM_SIZE:
		team_data.append(fish_data)
		update_team_display()
		
		if visible and team_data.size() == 1:
			select_fish(0)
		
		return true
	else:
		print("¡Equipo lleno! No puedes agregar más peces.")
		return false

func remove_fish_from_team(index: int):
	if index >= 0 and index < team_data.size():
		team_data.remove_at(index)
		update_team_display()
		
		if selected_index >= team_data.size():
			if team_data.size() > 0:
				select_fish(team_data.size() - 1)
			else:
				fish_info_panel.clear_info()

func update_fish_hp(index: int, current_hp: int):
	if index >= 0 and index < team_data.size():
		team_data[index].current_hp = current_hp
		if index < fish_slots.size():
			fish_slots[index].update_hp(current_hp, team_data[index].max_hp)

func get_team() -> Array:
	return team_data

func is_team_full() -> bool:
	return team_data.size() >= MAX_TEAM_SIZE

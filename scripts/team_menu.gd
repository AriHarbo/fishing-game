extends Control

# Referencia a la escena del FishSlot
const FishSlotScene = preload("res://scenes/ui/fish_slot.tscn")

# Container donde irán los slots
# IMPORTANTE: Ajusta esta ruta según tu estructura de nodos
@onready var slots_container: VBoxContainer = $Background/MarginContainer/VBoxContainer

# Array con los slots creados
var fish_slots: Array = []

# Máximo de peces en el equipo
const MAX_TEAM_SIZE = 4

# Datos del equipo (ejemplo)
var team_data: Array = []

func _ready():
	create_slots()
	visible = false
	# Asegurarse de que el nodo puede procesar inputs
	set_process_input(true)
	
	# Cargar datos de prueba (opcional, comenta esta línea en producción)
	load_test_data()

func _input(event):
	# Presionar Tab para abrir/cerrar el menú
	if event.is_action_pressed("ui_team"):
		toggle_menu()
		get_viewport().set_input_as_handled()

func toggle_menu():
	visible = not visible
	print("👁️  Menú visible: ", visible)
	print("📍 Posición: ", global_position, " | Tamaño: ", size)
	
	if visible:
		update_team_display()
		print("🔄 update_team_display() ejecutado")

func create_slots():
	# Limpiar slots existentes
	for child in slots_container.get_children():
		child.queue_free()
	
	fish_slots.clear()
	
	# Crear los slots vacíos
	for i in range(MAX_TEAM_SIZE):
		var slot = FishSlotScene.instantiate()
		slots_container.add_child(slot)
		fish_slots.append(slot)

func update_team_display():
	# Actualizar cada slot con los datos del equipo
	for i in range(MAX_TEAM_SIZE):
		if i < team_data.size():
			fish_slots[i].set_fish(team_data[i])
		else:
			fish_slots[i].clear_slot()

# Función para agregar un pez al equipo
func add_fish_to_team(fish_data: Dictionary) -> bool:
	if team_data.size() < MAX_TEAM_SIZE:
		team_data.append(fish_data)
		update_team_display()
		return true
	return false

# Función para remover un pez del equipo
func remove_fish_from_team(index: int):
	if index >= 0 and index < team_data.size():
		team_data.remove_at(index)
		update_team_display()

# Función para actualizar HP de un pez
func update_fish_hp(index: int, current_hp: int):
	if index >= 0 and index < team_data.size():
		team_data[index]["current_hp"] = current_hp
		if index < fish_slots.size():
			fish_slots[index].update_hp(current_hp, team_data[index]["max_hp"])

# Ejemplo de cómo cargar datos de prueba
func load_test_data():
	team_data = [
		{
			"name": "Carpa",
			"icon": preload("res://assets/fishes/carpa.png"),
			"current_hp": 28,
			"max_hp": 28,
			"elements": ["water"]
		}
	]
	update_team_display()

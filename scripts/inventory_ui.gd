extends CanvasLayer

@onready var inventory_grid = $TextureRect/BottomSection/InventoryGrid # Ajusta la ruta según tu estructura

var inventory_manager: InventoryManager
var inventory_slots: Array[InventorySlot] = []

var slot_hat: InventorySlot
var slot_torso: InventorySlot
var slot_legs: InventorySlot
var slot_rod: InventorySlot
var slot_bait: InventorySlot

# Cargar la escena del slot
var slot_scene = preload("res://scenes/inventory_slot.tscn")  # Ajusta la ruta si es diferente

func _ready():
	visible = false
	
	var player = get_tree().get_first_node_in_group("player")
	if player:
		inventory_manager = player.get_node_or_null("InventoryManager")
		if inventory_manager:
			inventory_manager.inventory_changed.connect(_on_inventory_changed)
			inventory_manager.equipment_changed.connect(_on_equipment_changed)
			
			call_deferred("setup_inventory")

func setup_inventory():
	create_inventory_slots()
	setup_equipment_slots()

func setup_equipment_slots():
	# Configurar slots de equipamiento
	slot_hat = get_node_or_null("TextureRect/TopSection/HBoxContainer/EquipmentLeft/SlotHat")
	if slot_hat:
		slot_hat.is_equipment_slot = true
		slot_hat.equipment_type = Item.ItemType.HAT
		slot_hat.inventory_manager = inventory_manager
	
	slot_torso = get_node_or_null("TextureRect/TopSection/HBoxContainer/EquipmentLeft/SlotTorso")
	if slot_torso:
		slot_torso.is_equipment_slot = true
		slot_torso.equipment_type = Item.ItemType.TORSO
		slot_torso.inventory_manager = inventory_manager
	
	slot_legs = get_node_or_null("TextureRect/TopSection/HBoxContainer/EquipmentLeft/SlotLegs")
	if slot_legs:
		slot_legs.is_equipment_slot = true
		slot_legs.equipment_type = Item.ItemType.LEGS
		slot_legs.inventory_manager = inventory_manager
	
	slot_rod = get_node_or_null("TextureRect/TopSection/HBoxContainer/EquipmentRight/SlotRod")
	if slot_rod:
		slot_rod.is_equipment_slot = true
		slot_rod.equipment_type = Item.ItemType.FISHING_ROD
		slot_rod.inventory_manager = inventory_manager
	
	slot_bait = get_node_or_null("TextureRect/TopSection/HBoxContainer/EquipmentRight/SlotBait")
	if slot_bait:
		slot_bait.is_equipment_slot = true
		slot_bait.equipment_type = Item.ItemType.BAIT
		slot_bait.inventory_manager = inventory_manager
	
	update_equipment_display()

func update_equipment_display():
	if slot_hat:
		slot_hat.set_item(inventory_manager.equipped_hat)
	if slot_torso:
		slot_torso.set_item(inventory_manager.equipped_torso)
	if slot_legs:
		slot_legs.set_item(inventory_manager.equipped_legs)
	if slot_rod:
		slot_rod.set_item(inventory_manager.equipped_rod)
	if slot_bait:
		slot_bait.set_item(inventory_manager.equipped_bait)

func create_inventory_slots():
	# Limpiar slots existentes (si los hay)
	for child in inventory_grid.get_children():
		child.queue_free()
	inventory_slots.clear()
	
	# Crear 24 slots (o el número que definiste en INVENTORY_SIZE)
	for i in range(inventory_manager.INVENTORY_SIZE):
		var slot = slot_scene.instantiate()
		slot.slot_index = i
		slot.inventory_manager = inventory_manager
		slot.slot_clicked.connect(_on_slot_clicked)
		
		inventory_grid.add_child(slot)
		inventory_slots.append(slot)
	
	# Actualizar la UI inicial
	update_inventory_display()

func update_inventory_display():
	# Actualizar cada slot con su item correspondiente
	for i in range(inventory_slots.size()):
		var item = inventory_manager.inventory[i]
		inventory_slots[i].set_item(item)

func _on_inventory_changed():
	# Cuando el inventario cambia, actualizar la UI
	update_inventory_display()

func _on_equipment_changed():
	update_equipment_display()

func _on_slot_clicked(slot: InventorySlot):
	# Por ahora solo debug
	if slot.stored_item:
		print("Clicked slot ", slot.slot_index, " - Item: ", slot.stored_item.name)
	else:
		print("Clicked empty slot ", slot.slot_index)

func _input(event):
	if event.is_action_pressed("ui_inventory"):
		toggle_inventory()

func toggle_inventory():
	visible = !visible
	# Actualizar la UI al abrir
	if visible:
		update_inventory_display()
		update_equipment_display()



func _on_close_button_pressed() -> void:
	toggle_inventory();

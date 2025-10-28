extends Node
class_name InventoryManager

const INVENTORY_SIZE = 16

# variables para guardar items
var inventory: Array[Item] = []  # Inventario general
var equipped_hat: Item = null
var equipped_torso: Item = null
var equipped_legs: Item = null
var equipped_rod: Item = null
var equipped_bait: Item = null

# Señales para actualizar la UI
signal inventory_changed
signal equipment_changed

func _ready():
	# Inicializar el inventario con slots vacíos
	inventory.resize(INVENTORY_SIZE)
	for i in range(INVENTORY_SIZE):
		inventory[i] = null
		
# Agregar item al inventario
func add_item(item: Item) -> bool:
	# Si es apilable, buscar si ya existe
	if item.stackable:
		for i in range(inventory.size()):
			if inventory[i] != null and inventory[i].id == item.id:
				if inventory[i].quantity < inventory[i].max_stack:
					inventory[i].quantity += item.quantity
					inventory_changed.emit()
					return true
	for i in range(inventory.size()):
			if inventory[i] != null and inventory[i].id == item.id:
				return false
	for i in range(inventory.size()):
		if inventory[i] == null:
			inventory[i] = item.duplicate_item()
			inventory_changed.emit()
			return true
	
	# Inventario lleno
	print("Inventario lleno!")
	return false
	
# Mover item entre slots del inventario
func move_item(from_index: int, to_index: int):
	if from_index < 0 or from_index >= inventory.size():
		return
	if to_index < 0 or to_index >= inventory.size():
		return
	
	# Intercambiar items
	var temp = inventory[from_index]
	inventory[from_index] = inventory[to_index]
	inventory[to_index] = temp
	inventory_changed.emit()

# Equipar item desde el inventario
func equip_item(inventory_index: int) -> bool:
	var item = inventory[inventory_index]
	if item == null:
		return false
	
	# Verificar que el item se pueda equipar
	match item.type:
		Item.ItemType.FISHING_ROD:
			# Si ya hay algo equipado, devolverlo al inventario
			if equipped_rod != null:
				inventory[inventory_index] = equipped_rod
			else:
				inventory[inventory_index] = null
			equipped_rod = item
		Item.ItemType.BAIT:
			if equipped_bait != null:
				inventory[inventory_index] = equipped_bait
			else:
				inventory[inventory_index] = null
			equipped_bait = item
		Item.ItemType.HAT:
			if equipped_hat != null:
				inventory[inventory_index] = equipped_hat
			else:
				inventory[inventory_index] = null
			equipped_hat = item
		Item.ItemType.TORSO:
			if equipped_torso != null:
				inventory[inventory_index] = equipped_torso
			else:
				inventory[inventory_index] = null
			equipped_torso = item
		Item.ItemType.LEGS:
			if equipped_legs != null:
				inventory[inventory_index] = equipped_legs
			else:
				inventory[inventory_index] = null
			equipped_legs = item
		_:
			return false
	
	equipment_changed.emit()
	inventory_changed.emit()
	return true

# Desequipar item (devolverlo al inventario)
func unequip_item(slot_type: Item.ItemType) -> bool:
	var item_to_unequip: Item = null
	
	match slot_type:
		Item.ItemType.FISHING_ROD:
			item_to_unequip = equipped_rod
			equipped_rod = null
		Item.ItemType.BAIT:
			item_to_unequip = equipped_bait
			equipped_bait = null
		Item.ItemType.HAT:
			item_to_unequip = equipped_hat
			equipped_hat = null
		Item.ItemType.TORSO:
			item_to_unequip = equipped_torso
			equipped_torso = null
		Item.ItemType.LEGS:
			item_to_unequip = equipped_legs
			equipped_legs = null
	
	if item_to_unequip != null:
		if add_item(item_to_unequip):
			equipment_changed.emit()
			return true
	
	return false

# Equipar desde un slot específico del inventario
func equip_item_from_slot(inventory_index: int, target_type: Item.ItemType) -> bool:
	var item = inventory[inventory_index]
	if item == null or item.type != target_type:
		return false
	
	# Similar a equip_item pero más específico
	return equip_item(inventory_index)

# Intercambiar entre slots de equipamiento
func swap_equipment(from_type: Item.ItemType, to_type: Item.ItemType):
	# Por ahora no permitir esto (slots de equipamiento diferentes)
	pass

# Desequipar a un slot específico del inventario
func unequip_to_slot(equip_type: Item.ItemType, target_slot: int) -> bool:
	if target_slot < 0 or target_slot >= inventory.size():
		return false
	
	# Si el slot destino está ocupado, no hacer nada
	if inventory[target_slot] != null:
		return false
	
	var item_to_unequip: Item = null
	
	match equip_type:
		Item.ItemType.FISHING_ROD:
			item_to_unequip = equipped_rod
			equipped_rod = null
		Item.ItemType.BAIT:
			item_to_unequip = equipped_bait
			equipped_bait = null
		Item.ItemType.HAT:
			item_to_unequip = equipped_hat
			equipped_hat = null
		Item.ItemType.TORSO:
			item_to_unequip = equipped_torso
			equipped_torso = null
		Item.ItemType.LEGS:
			item_to_unequip = equipped_legs
			equipped_legs = null
	
	if item_to_unequip:
		inventory[target_slot] = item_to_unequip
		equipment_changed.emit()
		inventory_changed.emit()
		return true
	
	return false

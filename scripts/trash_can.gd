extends Control

@onready var trash_icon: TextureRect = $TrashIcon

var trash_closed: Texture2D
var trash_open: Texture2D

var is_hovering: bool = false

func _ready():
	# Cargar los sprites
	trash_closed = load("res://assets/ui/inventory/closedTrashCan.png")
	trash_open = load("res://assets/ui/inventory/openedTrashCan.png")
	
	trash_icon.texture = trash_closed

# Detectar cuando un item se arrastra sobre la papelera
func _can_drop_data(at_position: Vector2, data) -> bool:
	if data is Dictionary and data.has("from_slot"):
		# Abrir la papelera visualmente
		trash_icon.texture = trash_open
		is_hovering = true
		return true
	return false

# Cuando sueltan el item
func _drop_data(at_position: Vector2, data):
	if data.has("from_slot") and data.has("item"):
		var from_slot: InventorySlot = data["from_slot"]
		print("Item eliminado: ", data["item"].name)
		
		# Eliminar el item del inventario
		if from_slot.is_equipment_slot:
			# Si viene de equipamiento, desequipar
			from_slot.inventory_manager.unequip_item(from_slot.equipment_type)
		else:
			# Si viene del inventario, eliminar del slot
			from_slot.inventory_manager.inventory[from_slot.slot_index] = null
			from_slot.inventory_manager.inventory_changed.emit()
		
		# Cerrar la papelera
		trash_icon.texture = trash_closed
		is_hovering = false

# Si sales sin soltar, cerrar la papelera
func _notification(what):
	if what == NOTIFICATION_MOUSE_EXIT:
		if is_hovering:
			trash_icon.texture = trash_closed
			is_hovering = false

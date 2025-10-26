extends Panel
class_name InventorySlot

@onready var item_icon: TextureRect = $ItemIcon
@onready var quantity_label: Label = $QuantityLabel

var slot_index: int = -1
var stored_item: Item = null
var inventory_manager: InventoryManager

# NUEVO: Tipo de slot de equipamiento (null = inventario normal)
var equipment_type: Item.ItemType = Item.ItemType.GENERIC
var is_equipment_slot: bool = false

signal slot_clicked(slot: InventorySlot)

func _ready():
	if item_icon:
		item_icon.visible = false
	gui_input.connect(_on_gui_input)

func set_item(item: Item):
	stored_item = item
	
	if item == null:
		item_icon.visible = false
		if quantity_label:
			quantity_label.visible = false
	else:
		item_icon.texture = item.icon
		item_icon.visible = true
		
		if quantity_label and item.stackable and item.quantity > 1:
			quantity_label.text = str(item.quantity)
			quantity_label.visible = true
		elif quantity_label:
			quantity_label.visible = false

func _on_gui_input(event: InputEvent):
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			slot_clicked.emit(self)

func _get_drag_data(at_position: Vector2):
	if stored_item == null:
		return null
	
	var preview = TextureRect.new()
	preview.texture = stored_item.icon
	preview.custom_minimum_size = Vector2(32, 32)
	preview.expand_mode = TextureRect.EXPAND_IGNORE_SIZE
	preview.stretch_mode = TextureRect.STRETCH_KEEP_ASPECT_CENTERED
	preview.modulate = Color(1, 1, 1, 0.7)
	set_drag_preview(preview)
	
	return {"from_slot": self, "item": stored_item}

func _can_drop_data(at_position: Vector2, data) -> bool:
	if not (data is Dictionary and data.has("from_slot")):
		return false
	
	# Si este es un slot de equipamiento, validar el tipo
	if is_equipment_slot:
		var dragged_item: Item = data["item"]
		# Solo permitir items del tipo correcto
		return dragged_item.type == equipment_type
	
	return true

func _drop_data(at_position: Vector2, data):
	if data.has("from_slot"):
		var from_slot: InventorySlot = data["from_slot"]
		
		if is_equipment_slot:
			# Equipar desde inventario a slot de equipamiento
			if not from_slot.is_equipment_slot:
				inventory_manager.equip_item_from_slot(from_slot.slot_index, equipment_type)
			else:
				# Intercambiar entre slots de equipamiento
				inventory_manager.swap_equipment(from_slot.equipment_type, equipment_type)
		elif from_slot.is_equipment_slot:
			# Desequipar a inventario
			inventory_manager.unequip_to_slot(from_slot.equipment_type, slot_index)
		else:
			# Mover entre slots de inventario normal
			inventory_manager.move_item(from_slot.slot_index, slot_index)

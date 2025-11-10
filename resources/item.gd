extends Resource
class_name Item

# Propiedades básicas del item
@export var id: String = ""  # Identificador único
@export var name: String = ""  # Nombre mostrado
@export var description: String = ""  # Descripción
@export var icon: Texture2D  # Sprite del item
@export var stackable: bool = false  # ¿Es stackeable?
@export var max_stack: int = 1  # Cantidad máxima en un stack

# Tipo de item (para saber dónde se puede equipar)
enum ItemType { GENERIC, FISHING_ROD, BAIT, HAT, TORSO, LEGS }
@export var type: ItemType = ItemType.GENERIC

# Para items apilables
var quantity: int = 1

# Crear copia del item
func duplicate_item() -> Item:
	var new_item = Item.new()
	new_item.id = id
	new_item.name = name
	new_item.description = description
	new_item.icon = icon
	new_item.stackable = stackable
	new_item.max_stack = max_stack
	new_item.type = type
	new_item.quantity = quantity
	return new_item

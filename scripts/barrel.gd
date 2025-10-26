extends Interactable

@export var item_to_give: Item

func _ready():
	super._ready()
	print("Barril _ready() - Item to give: ", item_to_give)
	if item_to_give:
		print("Item name: ", item_to_give.name)
		print("Item type: ", item_to_give.type)

func interact():
	super.interact()
	print("=== INTERACT LLAMADO ===")
	print("Item to give: ", item_to_give)
	
	# Verificar que el item existe
	if item_to_give == null:
		print("Error: No hay item asignado al barril")
		return
	
	print("Buscando jugador...")
	# Buscar el inventario del jugador
	var player = get_tree().get_first_node_in_group("player")
	print("Player encontrado: ", player)
	
	if player:
		var inventory_manager = player.get_node_or_null("InventoryManager")
		print("InventoryManager: ", inventory_manager)
		
		if inventory_manager:
			# Crear una copia del item
			var item_copy = item_to_give.duplicate_item()
			print("Intentando agregar item...")
			if inventory_manager.add_item(item_copy):
				print("¡Recibiste: ", item_to_give.name, "!")
			else:
				print("Inventario lleno!")
		else:
			print("Error: El jugador no tiene InventoryManager")
	else:
		print("Error: No se encontró el jugador")

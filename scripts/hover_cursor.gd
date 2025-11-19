extends Node
class_name HoverCursor

@export var hover_cursor_type: Input.CursorShape = Input.CURSOR_POINTING_HAND

func _ready():
	# Esperar un frame para asegurar que el padre esté listo
	await get_tree().process_frame
	_setup_connections()

func _setup_connections():
	var parent = get_parent()
	
	if not parent:
		push_error("HoverCursor: No hay parent")
		return
	
	# Verificar que el padre tenga las señales necesarias
	if not parent.has_signal("mouse_entered") or not parent.has_signal("mouse_exited"):
		push_error("HoverCursor: El parent no tiene las señales mouse_entered/exited")
		return
	
	# Conectar las señales
	if not parent.mouse_entered.is_connected(_on_mouse_entered):
		parent.mouse_entered.connect(_on_mouse_entered)
	
	if not parent.mouse_exited.is_connected(_on_mouse_exited):
		parent.mouse_exited.connect(_on_mouse_exited)

func _on_mouse_entered():
	Input.set_default_cursor_shape(hover_cursor_type)

func _on_mouse_exited():
	Input.set_default_cursor_shape(Input.CURSOR_ARROW)

extends CanvasLayer

func _ready():
	visible = false  # Empieza oculto

func _input(event):
	if event.is_action_pressed("ui_inventory"):  # Vamos a crear esta acción
		toggle_inventory()

func toggle_inventory():
	visible = !visible  # Alterna entre visible/invisible
	


func _on_close_button_pressed() -> void:
	visible = false

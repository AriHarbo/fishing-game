extends CanvasLayer

@onready var inv_ui = get_node(inventory_ui_path)
@export var inventory_ui_path: NodePath

@onready var team_ui = get_node(team_ui_path)
@export var team_ui_path: NodePath

func _on_inventory_button_pressed() -> void:
	inv_ui.toggle_inventory()


func _on_team_button_pressed() -> void:
	team_ui.toggle_menu()

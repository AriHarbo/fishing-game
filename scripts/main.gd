extends Node2D
@onready var team_menu = $MenuUI/TeamMenu

func _ready():
	var cursor_image = load("res://assets/ui/gameCursor.png")
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(0, 0))
	
	var cursor_grab = load("res://assets/ui/grabCursor.png")
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_DRAG, Vector2(0, 0))
	
	var cursor_hover = load("res://assets/ui/hoverCursor.png")
	Input.set_custom_mouse_cursor(cursor_hover, Input.CURSOR_POINTING_HAND, Vector2(0, 0))
	
	var zones = get_tree().get_nodes_in_group("fishing_zones")
	for zone in zones:
		zone.fish_caught.connect(_on_fish_caught)

	
func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_fish_caught(fish: FishData):
	$MenuUI/TeamMenu.add_fish_to_team(fish)

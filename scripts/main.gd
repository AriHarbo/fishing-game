extends Node2D

func _ready():
	var cursor_image = load("res://assets/ui/gameCursor.png")
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(0, 0))
	
	var cursor_grab = load("res://assets/ui/grabCursor.png")
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_DRAG, Vector2(0, 0))

func _process(delta):
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()

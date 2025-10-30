extends Button
class_name IconHoverButton

@export var icon_normal: Texture2D
@export var icon_hover: Texture2D
@export var icon_pressed: Texture2D  # Opcional

func _ready():
	mouse_entered.connect(_on_mouse_entered)
	mouse_exited.connect(_on_mouse_exited)
	button_down.connect(_on_button_down)
	button_up.connect(_on_button_up)
	
	icon = icon_normal

func _on_mouse_entered():
	if icon_hover:
		icon = icon_hover

func _on_mouse_exited():
	icon = icon_normal

func _on_button_down():
	if icon_pressed:
		icon = icon_pressed

func _on_button_up():
	if is_hovered():
		icon = icon_hover
	else:
		icon = icon_normal

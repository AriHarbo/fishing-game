extends Control
@onready var btn_continue = $VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/ButtonContinue

func _ready():
	var cursor_image = load("res://assets/ui/gameCursor.png")
	Input.set_custom_mouse_cursor(cursor_image, Input.CURSOR_ARROW, Vector2(0, 0))
	
	var cursor_grab = load("res://assets/ui/grabCursor.png")
	Input.set_custom_mouse_cursor(cursor_grab, Input.CURSOR_DRAG, Vector2(0, 0))
	
	var cursor_hover = load("res://assets/ui/hoverCursor.png")
	Input.set_custom_mouse_cursor(cursor_hover, Input.CURSOR_POINTING_HAND, Vector2(0, 0))
	# Por ahora, deshabilitar Continue si no hay sistema de guardado
	btn_continue.disabled = true
	
	# Conectar señales de los botones
	$VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/ButtonNewGame.pressed.connect(_on_new_game)
	$VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/ButtonContinue.pressed.connect(_on_continue)
	$VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/ButtonOptions.pressed.connect(_on_options)
	$VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/ButtonExit.pressed.connect(_on_exit)

func _on_new_game():
	print("Nueva partida iniciada")
	# Cambiar a la escena del juego
	get_tree().change_scene_to_file("res://scenes/main.tscn")  # Ajusta la ruta

func _on_continue():
	print("Continuar partida")
	# Cargar save y cambiar a la escena del juego
	# SaveManager.load_game()
	get_tree().change_scene_to_file("res://scenes/main.tscn")

func _on_options():
	print("Opciones (por implementar)")
	# Aquí irá el menú de opciones después

func _on_exit():
	print("Saliendo del juego")
	get_tree().quit()

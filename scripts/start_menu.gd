extends Control
@onready var btn_continue = $VBoxContainer/CenterContainer/PanelContainer/VBoxContainer/ButtonContinue

func _ready():
	# Verificar si existe un save para habilitar/deshabilitar Continue
	# (cuando implementes SaveManager)
	# btn_continue.disabled = not SaveManager.save_exists()
	
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

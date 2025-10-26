extends Node2D
# Definimos esta clase como "Interactable" para poder heredarla en otros scripts
class_name Interactable

# Referencias a los nodos hijos (se cargan cuando la escena está lista)
@onready var area = $Area2D  # Zona que detecta cuando el jugador está cerca
@onready var key_prompt = $KeyPrompt  # Sprite de la tecla E
@onready var visual = $Visual  # Sprite visual del objeto (barril, caja, etc.)

# Variable que guarda si el jugador está dentro del área de interacción
var player_nearby = false

# Señal que se emite cuando se interactúa con el objeto
# Otros scripts pueden conectarse a esta señal para reaccionar
signal interacted

func _ready():
	# Al iniciar, ocultamos la tecla E
	key_prompt.visible = false
	
	# Conectamos las señales del Area2D para detectar cuando algo entra/sale
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _process(_delta):
	z_index = int(global_position.y)
	# Cada frame verificamos si el jugador está cerca Y presiona E
	if player_nearby and Input.is_action_just_pressed("ui_interact"):
		interact()

# Se ejecuta cuando un cuerpo (body) entra en el Area2D
func _on_body_entered(body):
	# Verificamos que el cuerpo que entró sea el jugador
	if body.is_in_group("player"):
		player_nearby = true  # Marcamos que el jugador está cerca
		highlight(true)  # Activamos el resaltado visual
		key_prompt.visible = true  # Mostramos la tecla E

# Se ejecuta cuando un cuerpo sale del Area2D
func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false  # El jugador ya no está cerca
		highlight(false)  # Quitamos el resaltado
		key_prompt.visible = false  # Ocultamos la tecla E

# Función que maneja el efecto visual de resaltado
func highlight(enable: bool):
	if enable:
		# Hacemos el sprite más brillante (multiplicando RGB por 1.3)
		visual.modulate = Color(1.3, 1.3, 1.3, 1)
	else:
		# Volvemos al color original (1, 1, 1 = sin cambios)
		visual.modulate = Color(1, 1, 1, 1)

# Función que se llama cuando el jugador presiona E cerca del objeto
# Esta función está pensada para ser SOBRESCRITA en cada objeto específico
func interact():
	interacted.emit()  # Emitimos la señal por si alguien la está escuchando
	print("Interactuando con: ", name)  # Debug: imprime qué objeto se interactuó

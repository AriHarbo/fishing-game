extends Node2D
class_name FishingZone

@onready var area = $Area2D
@onready var area_clickeable = $AreaClickeable
@onready var visual = $Visual  # AnimatedSprite2D
@onready var key_prompt = $KeyPrompt

var mouse_hovering = false
var player_nearby = false

enum ZoneType { COMMON, UNCOMMON, RARE }
@export var zone_type: ZoneType = ZoneType.COMMON

signal fishing_started(zone: FishingZone)

func _ready():
	key_prompt.visible = false
	
	# Conectar señales del Area2D
	area_clickeable.mouse_entered.connect(_on_mouse_entered)
	area_clickeable.mouse_exited.connect(_on_mouse_exited)
	area.body_entered.connect(_on_body_entered)
	area.body_exited.connect(_on_body_exited)

func _input(event):
	# Detectar click solo si mouse está encima Y jugador cerca
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if mouse_hovering and player_nearby:
				start_fishing()

func _on_mouse_entered():
	mouse_hovering = true
	if player_nearby:
		highlight(true)

func _on_mouse_exited():
	mouse_hovering = false
	highlight(false)

func _on_body_entered(body):
	if body.is_in_group("player"):
		player_nearby = true
		highlight(true)
		key_prompt.visible = true

func _on_body_exited(body):
	if body.is_in_group("player"):
		player_nearby = false
		highlight(false)
		key_prompt.visible = false

func highlight(enable: bool):
	if enable:
		visual.modulate = Color(1.3, 1.3, 1.3, 1)  # Más brillante
	else:
		visual.modulate = Color(1, 1, 1, 1)

func start_fishing():
	print("¡Iniciando pesca en zona tipo: ", zone_type, "!")
	fishing_started.emit(self)
	# Aquí conectaremos con el FishingController

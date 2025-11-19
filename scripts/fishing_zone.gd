extends Node2D
class_name FishingZone

@onready var visual = $Visual
@onready var area_player = $Area2D
@onready var key_prompt = $KeyPrompt

var player_nearby: bool = false

@export var fish_pool: Array[FishData] = []
@export var fish_weights: Array[float] = []

signal fish_caught(fish: FishData)

func _ready():
	print("FishingZone _ready()")
	key_prompt.visible = false
	
	if area_player:
		area_player.body_entered.connect(_on_player_entered)
		area_player.body_exited.connect(_on_player_exited)
		print("Area player conectada")
	else:
		print("ERROR: area_player es null!")
	
	validate_fish_pool()
	print("Fish pool size: ", fish_pool.size())

func _input(event):
	if event.is_action_pressed("ui_interact"):
		print("Tecla E presionada! Player nearby: ", player_nearby)
		if player_nearby:
			print("¡Iniciando pesca con E!")
			catch_fish()
			get_viewport().set_input_as_handled()

func _on_player_entered(body):
	print("Body entró: ", body.name, " - Es player? ", body.is_in_group("player"))
	if body.is_in_group("player"):
		player_nearby = true
		key_prompt.visible = true
		visual.modulate = Color(1.3, 1.3, 1.3)
		print("Player CERCA = true")

func _on_player_exited(body):
	print("Body salió: ", body.name)
	if body.is_in_group("player"):
		player_nearby = false
		key_prompt.visible = false
		visual.modulate = Color.WHITE
		print("Player CERCA = false")

func catch_fish():
	var fish = get_random_fish()
	if fish:
		print("¡Pescaste: ", fish.fish_name, "!")
		fish_caught.emit(fish)
	else:
		print("ERROR: No se pudo obtener pez")

func get_random_fish() -> FishData:
	if fish_pool.is_empty():
		print("ERROR: fish_pool está vacío!")
		return null
	
	var total = 0.0
	for w in fish_weights:
		total += w
	
	var rand = randf() * total
	var accum = 0.0
	
	for i in fish_pool.size():
		accum += fish_weights[i]
		if rand <= accum:
			return fish_pool[i].duplicate_fish()
	
	return fish_pool[0].duplicate_fish()

func validate_fish_pool():
	while fish_weights.size() < fish_pool.size():
		fish_weights.append(1.0)

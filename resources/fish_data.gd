class_name FishData
extends Resource

# ===== CORE =====
@export var id: String = ""
@export var fish_name: String = ""
@export_multiline var description: String = ""
@export var sprite: Texture2D
@export var elements: Array[String] = []
@export_enum("Common", "Rare", "Epic", "Legendary") var rarity: String = "Common"

# ===== COMBAT STATS =====
@export_group("Combat Stats")
@export var level: int = 1
@export var current_hp: int = 20
@export var max_hp: int = 20
@export var base_atk: int = 10
@export var base_def: int = 10
@export var base_spd: int = 10

# ===== PROGRESSION =====
@export_group("Experience")
@export var current_exp: int = 0
@export var exp_to_next_level: int = 100
@export_enum("Fast", "Medium", "Slow") var exp_curve: String = "Medium"

# ===== ABILITIES =====
@export_group("Abilities")
@export var moves: Array[MoveData] = []  # Array de 4 moves máximo
@export var passive_ability: String = ""
@export_multiline var passive_description: String = ""

# ===== STATUS =====
@export_group("Status")
@export_enum("Normal", "Poisoned", "Burned", "Paralyzed", "Frozen", "Asleep") var status: String = "Normal"

# ===== POKEDEX DATA =====
@export_group("Collection Data")
@export var weight: float = 1.0  # kg
@export var size: float = 30.0   # cm
@export var catch_location: String = ""

# ===== FUNCIONES ÚTILES =====

# Calcular stats según nivel (puedes personalizar las fórmulas)
func get_current_atk() -> int:
	return base_atk + (level * 2)

func get_current_def() -> int:
	return base_def + (level * 2)

func get_current_spd() -> int:
	return base_spd + (level * 1)

# Recibir daño
func take_damage(damage: int):
	current_hp = max(0, current_hp - damage)

# Curar
func heal(amount: int):
	current_hp = min(max_hp, current_hp + amount)

# Ganar experiencia
func gain_exp(amount: int) -> bool:  # Retorna true si subió de nivel
	current_exp += amount
	if current_exp >= exp_to_next_level:
		return level_up()
	return false

# Subir de nivel
func level_up() -> bool:
	if level >= 100:  # Nivel máximo
		return false
	
	level += 1
	current_exp = 0
	
	# Calcular exp
	match exp_curve:
		"Fast":
			exp_to_next_level = int(80 * pow(level, 2))
		"Medium":
			exp_to_next_level = int(100 * pow(level, 2))
		"Slow":
			exp_to_next_level = int(125 * pow(level, 2))
	
	# Aumentar stats al subir de nivel
	max_hp += 5
	current_hp = max_hp  # Curar al subir de nivel
	base_atk += 2
	base_def += 2
	base_spd += 1
	
	return true

# Verificar si está vivo
func is_alive() -> bool:
	return current_hp > 0

# Clonar el pez
func duplicate_fish() -> FishData:
	var new_fish = duplicate(true)
	return new_fish

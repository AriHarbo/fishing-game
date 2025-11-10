class_name MoveData
extends Resource

@export var move_name: String = ""
@export var move_type: String = "normal"  # water, fire, earth, wind, normal
@export var power: int = 0  # 0 = move de soporte/buff
@export var accuracy: int = 100  # % de acierto
@export_multiline var description: String = ""
@export_enum("Physical", "Special", "Status") var category: String = "Physical"

# Efectos secundarios
@export_group("Effects")
@export_enum("None", "Poison", "Burn", "Paralyze", "Freeze", "Sleep", "Buff_ATK", "Buff_DEF", "Buff_SPD", "Debuff_ATK", "Debuff_DEF", "Debuff_SPD") var effect: String = "None"
@export_range(0, 100) var effect_chance: int = 0  # % de que se active el efecto

# Funcionalidades avanzadas (opcional)
@export var target_self: bool = false  # Si afecta al usuario o al enemigo
@export var hits: int = 1  # Cantidad de golpes (para multi-hit)
@export var priority: int = 0  # Moves con prioridad van primero

# Calcular daño base
func calculate_damage(attacker_atk: int, defender_def: int, level: int) -> int:
	if power == 0:
		return 0  # Move de soporte no hace daño
	
	# Fórmula de daño
	var damage = ((2 * level / 5 + 2) * power * attacker_atk / defender_def / 50) + 2
	
	# Variación aleatoria (85% - 100%)
	var random_factor = randf_range(0.85, 1.0)
	damage = int(damage * random_factor)
	
	return max(1, damage)  # Mínimo 1 de daño

# Verificar si el ataque acierta
func does_hit() -> bool:
	return randf() * 100 < accuracy

# Verificar si el efecto secundario se activa
func does_effect_trigger() -> bool:
	if effect == "None" or effect_chance == 0:
		return false
	return randf() * 100 < effect_chance

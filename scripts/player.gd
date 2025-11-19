extends CharacterBody2D
@onready var animated_sprite = $AnimatedSprite2D
func _process(_delta):
	z_index = int(global_position.y / 10)

	
func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left","right","up","down")
	if direction != Vector2.ZERO:
		velocity = direction * 200.0
	else:
		velocity = Vector2.ZERO
	update_sprite(direction)
	move_and_slide()	

func update_sprite(direction: Vector2):
	# Si no hay movimiento, mantener el sprite actual
	if direction == Vector2.ZERO:
		return
	
	# Cambiar el frame según la dirección
	
	# Adelante-derecha (S + D o solo D)
	if direction.x > 0 and direction.y >= 0:
		animated_sprite.frame = 0
	
	# Adelante-izquierda (S + A o solo A)
	elif direction.x < 0 and direction.y >= 0:
		animated_sprite.frame = 1
	
	# Atrás-derecha (W + D)
	elif direction.x > 0 and direction.y < 0:
		animated_sprite.frame = 3
	
	# Atrás-izquierda (W + A)
	elif direction.x < 0 and direction.y < 0:
		animated_sprite.frame = 2

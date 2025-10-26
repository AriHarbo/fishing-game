extends CharacterBody2D

func _physics_process(delta: float) -> void:
	var direction := Input.get_vector("left","right","up","down")
	if direction != Vector2.ZERO:
		velocity = direction * 50.0
	else:
		velocity = Vector2.ZERO
	move_and_slide()	

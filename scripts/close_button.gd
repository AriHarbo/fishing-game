extends TextureButton

func _on_mouse_entered():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1.15, 1.15), 0.12)
	tween.tween_property(self, "modulate", Color(1.3, 1.3, 1.3, 1), 0.12)

func _on_mouse_exited():
	var tween = create_tween()
	tween.set_parallel(true)
	tween.tween_property(self, "scale", Vector2(1, 1), 0.12)
	tween.tween_property(self, "modulate", Color(1, 1, 1, 1), 0.12)

extends StaticBody2D
var modo_arbusto = false

func desaparecer():
	if modo_arbusto:
		var tween = create_tween()
		tween.tween_property(self, "modulate", Color(1, 0, 0), 0.1)
		tween.tween_property(self, "modulate:a", 0, 0.2)
		tween.tween_callback(queue_free)

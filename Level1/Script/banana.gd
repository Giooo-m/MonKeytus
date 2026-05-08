extends Area2D

func _on_body_entered(body):
	if body.name == "Jugador":
		Global.puntos += 5 # Cada banana vale 5
		
		# Buscamos al generador en la escena actual
		var generador = get_tree().current_scene.find_child("Generador", true, false)
		
		if generador and generador.has_method("verificar_meta"):
			generador.verificar_meta()
		else:
			# Si el generador no aparece, checamos la meta desde aquí por seguridad
			if Global.puntos >= 50 and not Global.cinematica_iniciada:
				Global.cinematica_iniciada = true
				get_tree().call_deferred("change_scene_to_file", "res://Level2/Escenas/cambio.tscn")
		
		queue_free()

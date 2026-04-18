extends Area2D

func _on_body_entered(body):
	# Si el que entra es el Jugador
	if body.name == "Jugador":
		body.puntos += 5 # 5 puntos por banana 
		print("Bananas recolectadas! Total: ", body.puntos)
		queue_free() # La banana desaparece

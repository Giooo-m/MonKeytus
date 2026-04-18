extends Area2D

@export var velocidad: float = 400.0 # Velocidad de caída

func _process(delta):
	# El coco siempre cae hacia abajo
	position.y += velocidad * delta
	
	# Si el coco sale de la pantalla por abajo, se borra solo para no gastar memoria
	if position.y > 5000: 
		queue_free()

func _on_body_entered(body):
	# Verificamos si lo que tocó el coco es el "Jugador"
	if body.name == "Jugador" or body.is_in_group("jugador"):
		
		# REVISAMOS EL CONTADOR DE ESCUDOS
		# Usamos "get" por seguridad, si no encuentra la variable devuelve 0
		var escudos = body.get("escudos_acumulados")
		
		if escudos != null and escudos > 0:
			# EL MONO TIENE PROTECCIÓN
			if body.has_method("usar_escudo"):
				body.usar_escudo() # Esta función resta 1 y gestiona el color
			queue_free() # El coco se rompe
		else:
			# EL MONO NO TIENE ESCUDOS
			# Llamamos a morir con el mensaje personalizado
			body.morir("Un coco te ha golpeado!!!")
			queue_free()

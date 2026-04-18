extends Area2D

func _ready():
	# Forzamos la conexión por si la del editor está "zombie"
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	print("--- Escudo listo y esperando contacto ---")

func _on_body_entered(body):
	# ESTO APARECERÁ ABAJO EN LA PESTAÑA 'OUTPUT' o 'SALIDA'
	print("¡ALGO ME TOCÓ! Se llama: ", body.name)
	
	# Usamos un método que no falla: buscar por grupo o por tipo
	if body.has_method("activar_escudo"):
		print("Detecté al Jugador porque tiene la función activar_escudo")
		body.activar_escudo()
		queue_free()
	else:
		print("Lo que me tocó NO tiene la función activar_escudo")

extends Area2D

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	print("--- Escudo listo y esperando contacto ---")

func _on_body_entered(body):
	print("¡ALGO ME TOCÓ! Se llama: ", body.name)
	
	if body.has_method("activar_escudo"):
		print("Detecté al Jugador porque tiene la función activar_escudo")
		body.activar_escudo()
		queue_free()
	else:
		print("Lo que me tocó NO tiene la función activar_escudo")

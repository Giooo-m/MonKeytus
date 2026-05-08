extends Node2D

# 1. Precargamos la escena del fuego
var fuego_escena = preload("res://Level2/Escenas/fireball.tscn") 

func _on_timer_fireball_timeout() -> void:
	# 2. Creamos una instancia de la bola de fuego
	var nueva_bola = fuego_escena.instantiate()
	
	# 3. La añadimos a la escena
	add_child(nueva_bola)
	nueva_bola.position = Vector2(1200, randf_range(100, 500))

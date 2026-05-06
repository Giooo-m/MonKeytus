extends ColorRect

var velocidad = 1200 
var tiempo = 0.0

func _ready():
	# Si el shader no tiene el parámetro "time_shift", esta línea fallará. 
	# Si falla, bórrala o asegúrate de que el shader lo tenga.
	if material:
		material.set("shader_parameter/time_shift", randf() * 10.0)

func _process(delta):
	tiempo += delta
	
	# Movimiento hacia abajo
	global_position.y += velocidad * delta 
	
	# Desvanecimiento y auto-destrucción
	if tiempo > 4.0:
		modulate.a = 1.0 - (tiempo - 4.0)
	
	if tiempo > 5.0:
		queue_free()

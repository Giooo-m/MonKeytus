extends StaticBody2D

var velocidad = 150.0
var direccion = 1
var limite_izquierdo = 50
var limite_derecho = 1100

func _physics_process(delta):
	# Calculamos el movimiento de este frame
	var movimiento = velocidad * direccion * delta
	position.x += movimiento
	
	# Esto hace que el mono se mueva junto con la plataforma
	constant_linear_velocity.x = velocidad * direccion
	
	# Rebotar en los bordes
	if position.x >= limite_derecho:
		direccion = -1
	elif position.x <= limite_izquierdo:
		direccion = 1

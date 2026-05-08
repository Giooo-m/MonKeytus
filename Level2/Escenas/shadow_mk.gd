extends Area2D

# --- AJUSTES ---
@export var suavizado: float = 0.15
@export var retraso_frames: int = 75 

var historial_posiciones: Array = []
var historial_frames: Array = []
var historial_flip: Array = [] 

@onready var jugador = get_parent().get_node_or_null("Jugador")
@onready var sprite = $Sprite2D

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)
	
	z_index = -1 

func _physics_process(_delta):
	if jugador == null: return
	
	# 1. GRABAR: Guardamos posición, frame y dirección
	var sprite_jugador = jugador.get_node_or_null("Sprite2D")
	
	historial_posiciones.append(jugador.global_position)
	
	if sprite_jugador:
		historial_frames.append(sprite_jugador.frame)
		historial_flip.append(sprite_jugador.flip_h)
	else:
		historial_frames.append(7)
		historial_flip.append(false)
	
	# 2. SEGUIR Y REPLICAR (Validación Triple)
	# Solo entramos si todas las listas tienen el tamaño suficiente
	if historial_posiciones.size() > retraso_frames and historial_frames.size() > 0 and historial_flip.size() > 0:
		var destino = historial_posiciones.pop_front()
		var frame_viejo = historial_frames.pop_front()
		var flip_viejo = historial_flip.pop_front()
		
		# Movimiento fluido hacia el rastro
		global_position = global_position.lerp(destino, suavizado)
		
		# Aplicamos la pose y la dirección
		if sprite:
			sprite.frame = frame_viejo
			sprite.flip_h = flip_viejo

func _on_body_entered(body):
	if body.name == "Jugador":
		if body.has_method("morir"):
			body.morir("Shadow MK te alcanzo!!!")

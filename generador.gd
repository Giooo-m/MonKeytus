extends Node2D

var escena_plataforma = preload("res://plataforma.tscn")
var escena_arbusto = preload("res://arbusto.tscn")
var escena_banana = preload("res://banana.tscn")
var escena_movil = preload("res://plataforma_movil.tscn")
var escena_escudo = preload("res://escudo.tscn")
var escena_coco = preload("res://coco.tscn")

var ultima_pos_y = 600.0
var ancho_pantalla = 1152.0 
var distancia_fija = 90.0 

@onready var jugador = get_parent().get_node_or_null("Jugador")

func _ready():
	var timer_cocos = get_node_or_null("TimerCocos")
	if timer_cocos:
		timer_cocos.wait_time = 3.0
		timer_cocos.start()
	
	var base = escena_plataforma.instantiate()
	base.position = Vector2(ancho_pantalla / 2.0, 600)
	add_child(base)
	
	ultima_pos_y = 600.0
	for i in range(40):
		crear_fila_de_plataformas()

func _process(_delta):
	if jugador and jugador.global_position.y < ultima_pos_y + 1200:
		crear_fila_de_plataformas()

func crear_fila_de_plataformas():
	ultima_pos_y -= distancia_fija
	# Aquí solo llamamos a los sectores, la creación real ocurre abajo
	crear_en_sector(0.0, ancho_pantalla / 2.0)
	crear_en_sector(ancho_pantalla / 2.0, ancho_pantalla)

func crear_en_sector(x_min, x_max):
	var puntos_actuales = jugador.puntos if jugador else 0
	if randf() > 0.90: return 

	var nueva
	if puntos_actuales >= 200 and randf() < 0.70: 
		nueva = escena_movil.instantiate()
		if "velocidad" in nueva:
			nueva.velocidad = 180.0 + (puntos_actuales / 15.0) 
	else:
		if randf() > 0.40:
			nueva = escena_plataforma.instantiate()
		else:
			nueva = escena_arbusto.instantiate()

	var margen = 160.0
	var nueva_x = randf_range(x_min + margen, x_max - margen)
	var variacion_y = randf_range(-15, 15)
	
	nueva.position = Vector2(nueva_x, ultima_pos_y + variacion_y)
	add_child(nueva)

	# --- LÓGICA DE ITEMS (BANANA O ESCUDO) ---
	var azar = randf()
	if azar < 0.02: # 2% probabilidad de Escudo
		var esc = escena_escudo.instantiate()
		esc.position = Vector2(0, -55) # Se pega a la plataforma
		nueva.add_child(esc)
	elif azar < 0.35: # 30% probabilidad de Banana
		var ban = escena_banana.instantiate()
		ban.position = Vector2(0, -55) 
		nueva.add_child(ban)

func _on_timer_timeout():
	if jugador == null: return
	for i in range(2):
		var coco = escena_coco.instantiate()
		var x_pos = randf_range(100, ancho_pantalla - 100)
		var y_pos = jugador.global_position.y - 700 - (i * 200)
		coco.position = Vector2(x_pos, y_pos)
		get_parent().add_child(coco)

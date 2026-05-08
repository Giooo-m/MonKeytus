extends Node2D

# --- CONFIGURACIÓN ---
@export var nivel_dos: bool = false 

# --- PRECARGA DE ESCENAS ---
var escena_plataforma = preload("res://Level1/Escenas/plataforma.tscn")
var escena_arbusto = preload("res://Level1/Escenas/arbusto.tscn")
var escena_banana = preload("res://Level1/Escenas/banana.tscn")
var escena_movil = preload("res://Level1/Escenas/plataforma_movil.tscn")
var escena_escudo = preload("res://Level1/Escenas/escudo.tscn")
var escena_coco = preload("res://Level1/Escenas/coco.tscn")
var escena_plataforma2 = preload("res://Level2/Escenas/plataforma2.tscn")

var ultima_pos_y = 600.0
var ancho_pantalla = 1152.0 
var distancia_fija = 90.0 

@onready var jugador = get_parent().get_node_or_null("Jugador")

func _ready():
	var timer_cocos = get_node_or_null("TimerCocos")
	if timer_cocos:
		if not timer_cocos.timeout.is_connected(_on_timer_timeout):
			timer_cocos.timeout.connect(_on_timer_timeout)
		timer_cocos.wait_time = 3.0
		timer_cocos.start()
	
	# Base inicial
	var base = escena_plataforma.instantiate()
	if nivel_dos:
		var sprite = base.find_child("Sprite2D", true, false)
		var tex = load("res://Level2/Texturas/plataforma2.png")
		if sprite and tex:
			sprite.texture = tex
			sprite.region_enabled = false
			
	base.position = Vector2(ancho_pantalla / 2.0, 600)
	add_child(base)
	
	ultima_pos_y = 600.0
	for i in range(40):
		crear_fila_de_plataformas()

func _process(_delta):
	if jugador and jugador.global_position.y < ultima_pos_y + 200:
		crear_fila_de_plataformas()

func crear_fila_de_plataformas():
	ultima_pos_y -= distancia_fija
	crear_en_sector(0.0, ancho_pantalla / 2.0)
	crear_en_sector(ancho_pantalla / 2.0, ancho_pantalla)

func crear_en_sector(x_min, x_max):
	var puntos_actuales = Global.puntos
	if randf() > 0.90: return 

	var nueva
	if nivel_dos:
		# 1. Usamos escena del Nivel 2
		nueva = escena_plataforma2.instantiate()
		
		# 2. CARGA FORZADA DE TEXTURA
		var sprite = nueva.find_child("Sprite2D", true, false)
		var textura_n2 = load("res://Level2/Texturas/plataforma2.png")
		if sprite and textura_n2:
			sprite.texture = textura_n2
			sprite.region_enabled = false
		
		# 3. Lógica de trampa
		if randf() > 0.60:
			if "modo_arbusto" in nueva:
				nueva.modo_arbusto = true
	else:
		# NIVEL 1
		if puntos_actuales >= 200 and randf() < 0.70: 
			nueva = escena_movil.instantiate()
		else:
			nueva = escena_plataforma.instantiate() if randf() > 0.40 else escena_arbusto.instantiate()

	# POSICIONAMIENTO
	var margen = 160.0
	var nueva_x = randf_range(x_min + margen, x_max - margen)
	var variacion_y = randf_range(-15, 15)
	
	nueva.position = Vector2(nueva_x, ultima_pos_y + variacion_y)
	add_child(nueva)

	# --- AJUSTE DE BANANAS ---
	var azar = randf()
	if azar < 0.03: # 3% de probabilidad para escudo
		var esc = escena_escudo.instantiate()
		esc.position = Vector2(0, -48) 
		nueva.add_child(esc)
	elif azar < 0.35:
		var ban = escena_banana.instantiate()
		
		ban.position = Vector2(0, -48) 
		nueva.add_child(ban)
func verificar_meta():
	if Global.cinematica_iniciada: return 
	if Global.puntos >= 300 and not nivel_dos:
		Global.cinematica_iniciada = true 
		get_tree().call_deferred("change_scene_to_file", "res://Level2/Escenas/cambio.tscn")

func _on_timer_timeout():
	if jugador == null: return
	for i in range(2):
		var coco = escena_coco.instantiate()
		var x_pos = randf_range(100, ancho_pantalla - 100)
		var y_pos = jugador.global_position.y - 700 - (i * 200)
		coco.position = Vector2(x_pos, y_pos)
		get_parent().add_child(coco)

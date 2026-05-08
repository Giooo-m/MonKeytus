extends CharacterBody2D

# --- Variables de Movimiento ---
var velocidad = 400.0
var fuerza_salto = -1000.0
var gravedad = 1800.0

# --- Variables de Estado, Puntos y Escudos ---
var vivo = true
var escudos_acumulados = 0 
var puntos = 0 
var altura_maxima = 0.0

# --- Referencias Directas ---
@onready var sprite = $Sprite2D 

func _ready():
	# Sincronizamos los puntos al iniciar
	puntos = Global.puntos 
	await get_tree().process_frame
	altura_maxima = global_position.y
	actualizar_interfaz()
	actualizar_interfaz_escudo()
	if sprite:
		sprite.frame = 7 

func _physics_process(delta):
	if not vivo: return 

	# 1. Gravedad y Movimiento
	velocity.y += gravedad * delta
	
	var direccion = Input.get_axis("ui_left", "ui_right")
	
	var inclinar = Input.get_accelerometer().x
	if inclinar != 0:
		direccion += -inclinar * 0.5 
	
	velocity.x = clamp(direccion, -1, 1) * velocidad
	
	move_and_slide()

	# 2. ANIMACIÓN
	if is_on_floor():
		sprite.frame = 7
	else:
		if velocity.y < -50: 
			sprite.frame = 5
		elif velocity.y > 50:
			sprite.frame = 6

	if velocity.x > 0: sprite.flip_h = false
	elif velocity.x < 0: sprite.flip_h = true

# 3. LÓGICA DE SALTO Y RECOLECCIÓN
	if velocity.y > 0: 
		var colision = move_and_collide(Vector2(0, 18), true)
		if colision:
			var objeto = colision.get_collider()
			
			# Si chocamos con la parte superior (normal negativa en Y)
			if colision.get_normal().y < -0.5:
				velocity.y = fuerza_salto # Ejecutamos el salto
				
				# --- LÓGICA DE DESAPARICIÓN ---
				var objetivo_final = objeto
				
				# Si el cuerpo chocado no tiene el script, buscamos en su padre
				if not objeto.has_method("desaparecer") and objeto.get_parent() and objeto.get_parent().has_method("desaparecer"):
					objetivo_final = objeto.get_parent()
				
				# Si encontramos la función en el objeto o en el padre, la ejecutamos
				if objetivo_final.has_method("desaparecer"):
					objetivo_final.desaparecer()
					sumar_puntos(5)

	# 4. MUERTE POR CAÍDA Y LÍMITES
	if global_position.y < altura_maxima:
		altura_maxima = global_position.y
	
	if global_position.y > altura_maxima + 1100:
		morir("¡Te has caído!") 

	global_position.x = clamp(global_position.x, 20, 1132)	
	

# --- Funciones de Soporte ---

func sumar_puntos(cantidad: int):
	Global.puntos += cantidad # Sumamos directamente al Global
	puntos = Global.puntos    # Sincronizamos la variable local
	actualizar_interfaz()

func actualizar_interfaz():
	var label_puntos = get_tree().get_first_node_in_group("grupo_label_puntos")
	if label_puntos:
		label_puntos.text = str(puntos)
		var tween = create_tween()
		tween.tween_property(label_puntos, "scale", Vector2(1.2, 1.2), 0.1)
		tween.tween_property(label_puntos, "scale", Vector2(1.0, 1.0), 0.1)
	else:
		push_warning("Ojo: No encontré el grupo 'grupo_label_puntos'")

func actualizar_interfaz_escudo():
	var ui_escudo = get_tree().get_first_node_in_group("grupo_contenedor_escudo")
	var label_escudo = get_tree().get_first_node_in_group("grupo_label_escudo")
	
	if ui_escudo:
		if escudos_acumulados > 0:
			ui_escudo.show() 
			if label_escudo:
				label_escudo.text = "x" + str(escudos_acumulados)
				var tween = create_tween()
				tween.tween_property(label_escudo, "scale", Vector2(1.2, 1.2), 0.1)
				tween.tween_property(label_escudo, "scale", Vector2(1.0, 1.0), 0.1)
		else:
			ui_escudo.hide()
			
func morir(_mensaje: String = "¡Fin del Juego!"):
	if vivo:
		vivo = false
		get_tree().set_meta("razon_muerte", _mensaje)
		
		var musica = get_tree().current_scene.find_child("MusicaFondo", true, false)
		if musica:
			musica.stop() 

		# 1. Guardamos el record CON los puntos que tenemos ahora
		guardar_record()
		
		# 2. CARGAMOS EL CARTEL
		var escena_cartel = load("res://UI/interfaz_game_over.tscn")
		if escena_cartel:
			var cartel = escena_cartel.instantiate()
			# Pasamos los puntos al cartel si es necesario
			if "puntos_finales" in cartel:
				cartel.puntos_finales = Global.puntos 
			get_tree().current_scene.call_deferred("add_child", cartel)
		
func guardar_record():
	var record_actual = 0
	if FileAccess.file_exists("user://record.save"):
		var archivo = FileAccess.open("user://record.save", FileAccess.READ)
		if archivo:
			record_actual = archivo.get_32()
			archivo.close()
	
	if puntos > record_actual:
		var archivo = FileAccess.open("user://record.save", FileAccess.WRITE)
		if archivo:
			archivo.store_32(puntos)
			archivo.close()

# --- SISTEMA DE ESCUDOS ---

func activar_escudo():
	escudos_acumulados += 1
	modulate = Color(1, 1, 0) 
	actualizar_interfaz_escudo()

func usar_escudo():
	if escudos_acumulados > 0:
		escudos_acumulados -= 1
		var tween = create_tween()
		modulate = Color(1, 0, 0) 
		tween.tween_property(self, "modulate", Color(1, 1, 1), 0.2)
		if escudos_acumulados > 0:
			tween.tween_property(self, "modulate", Color(1, 1, 0), 0.2)
		actualizar_interfaz_escudo()

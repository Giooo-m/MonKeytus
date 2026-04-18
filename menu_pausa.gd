extends CanvasLayer

func _ready():
	# El menú empieza escondido
	hide()
	# Esto permite que el menú funcione aunque el juego esté pausado
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# --- CONEXIÓN DE SONIDO ---
	# Buscamos los botones que estén en el grupo "botones" dentro de este menú
	var mis_botones = get_tree().get_nodes_in_group("botones")
	for b in mis_botones:
		if not b.pressed.is_connected(_sonar_click):
			b.pressed.connect(_sonar_click)

func _sonar_click():
	# Usamos el Autoload que ya comprobamos que funciona
	if is_instance_valid(ReproductorClick):
		ReproductorClick.play()

func _input(event):
	# Si presionas la tecla "Esc" (ui_cancel)
	if event.is_action_pressed("ui_cancel"):
		alternar_pausa()

func alternar_pausa():
	var nuevo_estado = !get_tree().paused
	get_tree().paused = nuevo_estado
	visible = nuevo_estado

# --- Funciones para los botones ---

func _on_btn_continuar_pressed():
	alternar_pausa()

func _on_btn_reiniciar_pressed():
	# IMPORTANTE: Quitar la pausa antes de reiniciar o el juego empezará congelado
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_salir_pressed():
	# IMPORTANTE: Quitar la pausa antes de ir al menú
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu_inicio.tscn")

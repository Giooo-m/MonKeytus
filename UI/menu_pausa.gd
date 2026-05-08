extends CanvasLayer

func _ready():
	# El menú empieza escondido
	hide()
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	# --- CONEXIÓN DE SONIDO ---
	var mis_botones = get_tree().get_nodes_in_group("botones")
	for b in mis_botones:
		if not b.pressed.is_connected(_sonar_click):
			b.pressed.connect(_sonar_click)

func _sonar_click():
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
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/menu_inicio.tscn")

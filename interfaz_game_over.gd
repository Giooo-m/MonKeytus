extends CanvasLayer

var puntos_finales: int = 0 

func _ready():
	# --- 1. MOSTRAR LA RAZÓN DE LA MUERTE ---
	# Buscamos el nodo que se llama "Label"
	if has_node("Label"):
		# Leemos el "post-it" que dejamos en el mono (meta)
		if get_tree().has_meta("razon_muerte"):
			$Label.text = get_tree().get_meta("razon_muerte")
		else:
			$Label.text = "¡Fin del Juego!" # Por si acaso falla algo
	
	# 2. Mostramos las bananas que recolectaste
	if has_node("LabelPuntos"):
		$LabelPuntos.text = "Bananas Recolectadas: " + str(puntos_finales)
	
	# 3. Leemos el récord guardado
	var record = 0
	if FileAccess.file_exists("user://record.save"):
		var archivo = FileAccess.open("user://record.save", FileAccess.READ)
		if archivo:
			record = archivo.get_32()
			archivo.close()
	
	# 4. Mostramos el récord máximo histórico
	if has_node("LabelRecord"):
		$LabelRecord.text = "Record Máximo: " + str(record)

	# --- 5. CONEXIÓN DE SONIDO PARA BOTONES ---
	var mis_botones = get_tree().get_nodes_in_group("botones")
	for b in mis_botones:
		if not b.pressed.is_connected(_sonar_click):
			b.pressed.connect(_sonar_click)

func _sonar_click():
	if is_instance_valid(ReproductorClick):
		ReproductorClick.play()

func _on_btn_reiniciar_pressed():
	get_tree().paused = false
	get_tree().reload_current_scene()

func _on_btn_salir_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://menu_inicio.tscn")

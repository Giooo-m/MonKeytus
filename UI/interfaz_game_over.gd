extends CanvasLayer

func _ready():
	# 1. MOSTRAR LA RAZÓN DE LA MUERTE
	if has_node("Label"):
		if get_tree().has_meta("razon_muerte"):
			$Label.text = get_tree().get_meta("razon_muerte")
		else:
			$Label.text = "¡Fin del Juego!"
	
	# 2. MOSTRAR BANANAS RECOLECTADAS (DIRECTO DEL GLOBAL)
	if has_node("LabelPuntos"):
		$LabelPuntos.text = "Bananas Recolectadas: " + str(Global.puntos)
	
	# 3. ACTUALIZAR Y LEER EL RÉCORD
	var record_actual = 0
	if FileAccess.file_exists("user://record.save"):
		var archivo_lectura = FileAccess.open("user://record.save", FileAccess.READ)
		if archivo_lectura:
			record_actual = archivo_lectura.get_32()
			archivo_lectura.close()
	
	# Si los puntos de esta partida son mayores al récord, guardamos el nuevo
	if Global.puntos > record_actual:
		record_actual = Global.puntos
		var archivo_escritura = FileAccess.open("user://record.save", FileAccess.WRITE)
		if archivo_escritura:
			archivo_escritura.store_32(record_actual)
			archivo_escritura.close()
	
	# 4. MOSTRAR EL RÉCORD MÁXIMO
	if has_node("LabelRecord"):
		$LabelRecord.text = "Record Máximo: " + str(record_actual)

	# 5. CONEXIÓN DE SONIDO
	var mis_botones = get_tree().get_nodes_in_group("botones")
	for b in mis_botones:
		if not b.pressed.is_connected(_sonar_click):
			b.pressed.connect(_sonar_click)

func _sonar_click():
	if is_instance_valid(get_node_or_null("ReproductorClick")):
		$ReproductorClick.play()

func _on_btn_reiniciar_pressed():
	Global.puntos = 0
	Global.cinematica_iniciada = false
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/mundo.tscn")

func _on_btn_salir_pressed():
	Global.puntos = 0 
	get_tree().paused = false
	get_tree().change_scene_to_file("res://UI/menu_inicio.tscn")

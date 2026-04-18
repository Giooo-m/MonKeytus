extends Node2D

func _ready():
	# Buscamos los botones del grupo "botones"
	var mis_botones = get_tree().get_nodes_in_group("botones")
	print("Botones encontrados en el Menú: ", mis_botones.size())
	
	for b in mis_botones:
		# Conectamos cada botón a la función de sonido
		if not b.pressed.is_connected(_sonar_click):
			b.pressed.connect(_sonar_click)

func _sonar_click():
	# Intentamos llamar al Autoload por su nombre directo
	# Si se llama 'ReproductorClick' en la configuración, esto funcionará:
	if is_instance_valid(ReproductorClick):
		print("¡Tocando sonido desde Autoload!")
		ReproductorClick.play()
	else:
		# Si falla, buscamos el nodo de audio que tienes dentro de la escena MenuInicio (el de tu foto)
		var sonido_local = get_node_or_null("AudioStreamPlayer2D")
		if sonido_local:
			print("Usando sonido local porque el Autoload no respondió")
			sonido_local.play()
		else:
			print("ERROR: No se encontró ni el Autoload ni el sonido local")

# Tu función original para cambiar de escena
func _on_button_pressed():
	# Cambiamos al mundo
	get_tree().change_scene_to_file("res://mundo.tscn")

func _on_btn_info_pressed():
	# Cambiamos a info
	get_tree().change_scene_to_file("res://info.tscn")

func _on_btn_historia_pressed():
	# Cambiamos a cinematica
	get_tree().change_scene_to_file("res://historia.tscn")

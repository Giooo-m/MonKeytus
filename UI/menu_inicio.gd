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
	if is_instance_valid(ReproductorClick):
		print("¡Tocando sonido desde Autoload!")
		ReproductorClick.play()
	else:
		var sonido_local = get_node_or_null("AudioStreamPlayer2D")
		if sonido_local:
			print("Usando sonido local porque el Autoload no respondió")
			sonido_local.play()
		else:
			print("ERROR: No se encontró ni el Autoload ni el sonido local")

func _on_button_pressed():
	# Cambiamos al mundo
	get_tree().change_scene_to_file("res://UI/mundo.tscn")

func _on_btn_historia_pressed():
	# Cambiamos a cinematica
	get_tree().change_scene_to_file("res://UI/historia.tscn")

func _on_btn_play_pressed() -> void:
	pass

func _on_btn_info_pressed() -> void:
	get_tree().change_scene_to_file("res://UI/info.tscn")

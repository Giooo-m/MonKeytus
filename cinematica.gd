extends Control

# Se ejecuta al entrar a la escena
func _ready():
	# Si no activaste 'Autoplay' en el Inspector, quita el '#' de la línea de abajo:
	# $VideoStreamPlayer.play()
	pass

# CONECTAR AQUÍ: Señal 'pressed()' del botón "Omitir"
func _on_btn_omitir_pressed():
	get_tree().change_scene_to_file("res://menu_inicio.tscn")

# CONECTAR AQUÍ: Señal 'finished()' del VideoStreamPlayer
func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://menu_inicio.tscn")

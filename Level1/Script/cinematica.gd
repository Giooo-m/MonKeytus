extends Control

# Se ejecuta al entrar a la escena
func _ready():
	# $VideoStreamPlayer.play()
	pass

# CONECTAR AQUÍ: Señal 'pressed()' del botón "Omitir"
func _on_btn_omitir_pressed():
	get_tree().change_scene_to_file("res://UI/menu_inicio.tscn")

# CONECTAR AQUÍ: Señal 'finished()' del VideoStreamPlayer
func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://UI/menu_inicio.tscn")

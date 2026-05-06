extends Control

func _ready():
	pass

func _on_btn_omitir_pressed():
	get_tree().change_scene_to_file("res://menu_inicio.tscn")

func _on_video_stream_player_finished():
	get_tree().change_scene_to_file("res://menu_inicio.tscn")

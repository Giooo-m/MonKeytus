extends Node2D

var final_activado = false

@onready var jugador = $Jugador
@onready var video = $VideoStreamPlayer

func _process(delta):
	if not final_activado and jugador.puntos >= 240:
		final_activado = true
		iniciar_transicion()


func iniciar_transicion():
	print("VIDEO ACTIVADO")
	
	video.visible = true
	video.play()
	
	# Congela el juego
	get_tree().paused = true

func _on_video_stream_player_finished() -> void:
	get_tree().paused = true
	await get_tree().process_frame
	get_tree().change_scene_to_file("res://Mundo2.tscn")

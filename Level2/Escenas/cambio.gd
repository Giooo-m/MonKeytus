extends Control

func _ready():
	var player = $VideoStreamPlayer 
	await player.finished 
	
	get_tree().change_scene_to_file("res://Level2/Escenas/mundo2.tscn")

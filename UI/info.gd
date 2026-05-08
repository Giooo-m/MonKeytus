extends Control

func _on_button_pressed() -> void:
	print("¡El botón fue presionado correctamente!") 
	get_tree().change_scene_to_file("res://UI/menu_inicio.tscn")

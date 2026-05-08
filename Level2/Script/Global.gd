extends CanvasLayer

var puntos: int = 0
var razon_muerte: String = ""
var cinematica_iniciada: bool = false

func _ready():
	# 1. MOSTRAR LA RAZÓN DE LA MUERTE
	if has_node("Label"):
		if get_tree().has_meta("razon_muerte"):
			$Label.text = get_tree().get_meta("razon_muerte")
		else:
			$Label.text = "¡Fin del Juego!"

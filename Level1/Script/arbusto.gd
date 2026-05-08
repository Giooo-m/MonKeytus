extends StaticBody2D

func desaparecer():
	# un salto y desaparece
	await get_tree().create_timer(0.1).timeout
	queue_free()

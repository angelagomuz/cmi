extends TextureButton

var tween: Tween  

func _ready():
	
	pivot_offset = size * 0.5  
	start_scaling()
	connect("pressed", Callable(self, "_on_button_pressed"))  

func start_scaling():
	tween = create_tween()
	tween.set_loops()

	
	tween.tween_property(self, "scale", Vector2(1.1, 1.1), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)
	tween.tween_property(self, "scale", Vector2(1.0, 1.0), 0.6).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_IN_OUT)

func _on_button_pressed():
	if tween:
		tween.kill()  
	jump_effect()

func jump_effect():
	var jump_tween = create_tween()
	jump_tween.tween_property(self, "scale", Vector2(1.5, 1.5), 0.2).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
	jump_tween.tween_property(self, "modulate:a", 0, 0.2)  
	await jump_tween.finished
	change_scene()

func change_scene():
	var escena_destino = "res://escenas/2.tscn" 

	if ResourceLoader.exists(escena_destino):  
		get_tree().change_scene_to_file(escena_destino)
	else:
		print("ERROR: La escena no existe. Verifica la ruta.")

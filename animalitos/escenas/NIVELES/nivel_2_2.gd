extends Area2D

@export var velocidad := 150.0

func _ready():
	connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
	position.y += velocidad * delta
	if position.y > 600:
		queue_free()

func _on_body_entered(body):
	print("Colisión con: ", body.name)
	if body.name == "Perro":
		print("❌ Garrapata tocó al perro")
		if get_tree().current_scene.has_method("recibir_dano"):
			get_tree().current_scene.recibir_dano()
		queue_free()

extends CharacterBody2D

@export var velocidad := 300.0
@export var limite_izquierdo := -1000.0
@export var limite_derecho := 1024.0

func _process(delta):
	var direccion := 0

	if Input.is_action_pressed("ui_left"):
		direccion -= 1
	if Input.is_action_pressed("ui_right"):
		direccion += 1

	position.x += direccion * velocidad * delta
	position.x = clamp(position.x, limite_izquierdo, limite_derecho)

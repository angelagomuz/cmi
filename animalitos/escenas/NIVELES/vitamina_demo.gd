
extends Area2D

@export var velocidad := 150.0

func _ready():
    connect("body_entered", Callable(self, "_on_body_entered"))

func _process(delta):
    position.y += velocidad * delta
    if position.y > 600:
        queue_free()

func _on_body_entered(body):
    if body.name == "Perro":
        print("✅ ¡Colisión con el perro!")
        queue_free()

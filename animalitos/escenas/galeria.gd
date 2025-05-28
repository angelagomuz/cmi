extends Node2D  # o Control, si tu nodo raíz es de ese tipo

@onready var boton_galeria = $galeria

func _ready():
	boton_galeria.pressed.connect(_on_boton_galeria_pressed)

func _on_boton_galeria_pressed():
	get_tree().change_scene_to_file("res://galeria.tscn")  # Ajusta la ruta si está en otra carpeta

extends Node2D

@onready var boton_galeria: TextureButton = $BaseMenuDef/boton_galeria

func _ready():
	boton_galeria.pressed.connect(_on_boton_galeria_pressed)

func _on_boton_galeria_pressed() -> void:
	var galeria_scene = load("res://galeria.tscn")
	if galeria_scene:
		get_tree().change_scene_to_packed(galeria_scene)
	else:
		push_error("No se pudo cargar la escena 'galeria.tscn'")

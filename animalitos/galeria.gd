extends Node2D

@export var imagenes: Array[Texture2D] = []

var indice_actual: int = 0

@onready var imagen = $Imagen
@onready var btn_anterior = $BotonAnterior
@onready var btn_siguiente = $BotonSiguiente
@onready var boton_volver = $BotonVolver
@onready var click_player: AudioStreamPlayer = $botonclick  # ← CORREGIDO

func _ready():
	actualizar_imagen()

	btn_anterior.pressed.connect(_on_anterior_pressed)
	btn_siguiente.pressed.connect(_on_siguiente_pressed)
	boton_volver.pressed.connect(_on_boton_volver_pressed)

func actualizar_imagen():
	if imagenes.size() > 0:
		imagen.texture = imagenes[indice_actual]

func _on_anterior_pressed():
	click_player.play()
	indice_actual = (indice_actual - 1 + imagenes.size()) % imagenes.size()
	actualizar_imagen()

func _on_siguiente_pressed():
	click_player.play()
	indice_actual = (indice_actual + 1) % imagenes.size()
	actualizar_imagen()

func _on_boton_volver_pressed():
	click_player.play()
	await click_player.finished  # Espera a que suene el clic
	var escena_siguiente = load("res://escenas/5.tscn")
	if escena_siguiente:
		get_tree().change_scene_to_packed(escena_siguiente)
	else:
		push_error("No se pudo cargar la escena '5.tscn'")

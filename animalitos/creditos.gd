extends Node2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var boton_volver: TextureButton = $TextureButton
@onready var capa_texto: Node2D = $Capa2
@onready var click_player: AudioStreamPlayer = $clickboton  # Nuevo

var posicion_inicial := Vector2(960, 1100)

func _ready():
	# Posición inicial del texto
	capa_texto.position = posicion_inicial
	# Reproducir animación de créditos
	animation_player.play("creditos")
	# Conectar botón volver
	boton_volver.pressed.connect(_on_boton_volver_pressed)
	# Conectar la señal de final de animación al método
	animation_player.animation_finished.connect(_on_AnimationPlayer_animation_finished)

func _on_boton_volver_pressed():
	click_player.play()
	await click_player.finished  # Espera a que termine el sonido
	var escena_siguiente = load("res://escenas/5.tscn")
	if escena_siguiente:
		get_tree().change_scene_to_packed(escena_siguiente)
	else:
		push_error("No se pudo cargar la escena '5.tscn'")

func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "creditos":
		# Reinicia la posición y vuelve a reproducir la animación
		capa_texto.position = posicion_inicial
		animation_player.play("creditos")

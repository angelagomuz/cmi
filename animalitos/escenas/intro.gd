extends Control

@onready var video_player: VideoStreamPlayer = $VideoStreamPlayer
@onready var boton_reiniciar: TextureButton = $botonreiniciar
@onready var boton_skip: TextureButton = $botonskip
@onready var click_player: AudioStreamPlayer = $botonclick

func _ready():
	boton_reiniciar.pressed.connect(_on_boton_reiniciar_pressed)
	boton_skip.pressed.connect(_on_boton_skip_pressed)

func _on_boton_reiniciar_pressed():
	click_player.play()
	await click_player.finished
	get_tree().reload_current_scene()

func _on_boton_skip_pressed():
	click_player.play()
	await click_player.finished
	var siguiente_escena = load("res://escenas/NIVELES/NIVEL1.tscn")
	if siguiente_escena:
		get_tree().change_scene_to_packed(siguiente_escena)
	else:
		push_error("No se pudo cargar la escena 'NIVEL1.tscn'")

extends Node2D

@onready var boton_galeria: TextureButton = $BaseMenuDef/boton_galeria
@onready var boton_creditos: TextureButton = $BaseMenuDef/boton_creditos
@onready var boton_play: TextureButton = $BaseMenuDef/boton_play
@onready var boton_sonido: TextureButton = $BaseMenuDef/boton_sonido
@onready var click_player: AudioStreamPlayer = $BaseMenuDef/clickboton
@onready var musica: AudioStreamPlayer = $AudioStreamPlayer

var icono_mute := preload("res://png/mute.png")       # Acción: silenciar
var icono_volumen := preload("res://png/volume.png")  # Acción: volver a activar

var sonido_activo := true  # La música empieza sonando

func _ready():
	boton_galeria.pressed.connect(_on_boton_galeria_pressed)
	boton_creditos.pressed.connect(_on_boton_creditos_pressed)
	boton_play.pressed.connect(_on_boton_play_pressed)
	boton_sonido.pressed.connect(_on_boton_sonido_pressed)

	musica.volume_db = 0
	musica.stream.loop = true
	musica.play()

	boton_sonido.texture_normal = icono_mute

# Sonido de botón + cambio a escena galería
func _on_boton_galeria_pressed() -> void:
	click_player.play()
	await click_player.finished
	var galeria_scene = load("res://galeria.tscn")
	if galeria_scene:
		get_tree().change_scene_to_packed(galeria_scene)

# Sonido de botón + cambio a escena créditos
func _on_boton_creditos_pressed() -> void:
	click_player.play()
	await click_player.finished
	var creditos_scene = load("res://creditos.tscn")
	if creditos_scene:
		get_tree().change_scene_to_packed(creditos_scene)

# Sonido de botón + cambio a escena intro
func _on_boton_play_pressed() -> void:
	click_player.play()
	await click_player.finished
	var intro_scene = load("res://escenas/intro.tscn")
	if intro_scene:
		get_tree().change_scene_to_packed(intro_scene)

# Silenciar/activar música
func _on_boton_sonido_pressed() -> void:
	sonido_activo = !sonido_activo
	if sonido_activo:
		musica.volume_db = 0
		boton_sonido.texture_normal = icono_mute
	else:
		musica.volume_db = -80
		boton_sonido.texture_normal = icono_volumen

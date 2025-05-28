extends Node2D

@onready var musica_fondo = $MusicaFondo
@onready var sonido_captura = $SonidoCaptura
@onready var sonido_error = $SonidoError
@onready var sonido_click = $SonidoClick

@onready var dialogo = $DialogoInicial
@onready var boton_continuar = $DialogoInicial/DialogoPrevio/BotonContinuar

@onready var caballo = $Caballo
@onready var timer = $Timer

@onready var label_puntos = $UI/LabelPuntos
@onready var vidas = [
	$UI/VidasContainer/Vida1,
	$UI/VidasContainer/Vida2,
	$UI/VidasContainer/Vida3,
	$UI/VidasContainer/Vida4,
	$UI/VidasContainer/Vida5
]
@onready var UI = $UI

@onready var pantalla_victoria = $Victoria
@onready var video = $Victoria/VideoStreamPlayer
@onready var boton_creditos = $Victoria/BotonCreditos

@onready var pantalla_derrota = $Derrota
@onready var boton_reintentar = $Derrota/BotonReintentar

var caballos_atrapados = 0
var vidas_restantes = 5
var juego_activo = false

func _ready():
	musica_fondo.play()
	caballo.visible = false
	UI.visible = false
	timer.wait_time = 0.65
	timer.timeout.connect(_on_Timer_timeout)
	caballo.connect("input_event", _on_caballo_click)
	boton_continuar.pressed.connect(_empezar_juego)
	boton_creditos.pressed.connect(_ir_a_creditos)
	boton_reintentar.pressed.connect(_reiniciar_nivel)

func _empezar_juego():
	sonar_click()
	dialogo.visible = false
	UI.visible = true
	juego_activo = true
	_mover_caballo()

func _mover_caballo():
	if juego_activo:
		var x = randi() % 850 + 30    # x entre 30 y 880 (más ancho hacia la derecha)
		var y = randi() % 150 + 30    # y entre 30 y 180 (más margen arriba y abajo)
		var nueva_pos = Vector2(x, y)
		caballo.position = nueva_pos
		caballo.visible = true
		timer.start()




func _on_Timer_timeout():
	if caballo.visible:
		caballo.visible = false
		vidas_restantes -= 1
		if vidas_restantes >= 0 and vidas_restantes < vidas.size():
			vidas[vidas_restantes].visible = false
			sonido_error.play()
		if vidas_restantes == 0:
			_mostrar_derrota()
		else:
			_mover_caballo()

func _on_caballo_click(_viewport, event, _shape_idx):
	if not juego_activo:
		return
	if event is InputEventMouseButton and event.pressed:
		sonar_click()
		sonido_captura.play()
		caballos_atrapados += 1
		label_puntos.text = "%d/8 CABALLOS" % caballos_atrapados
		timer.stop()
		caballo.visible = false

		if caballos_atrapados >= 8:
			_mostrar_victoria()
		else:
			_mover_caballo()

func _mostrar_victoria():
	juego_activo = false
	pantalla_victoria.visible = true
	video.play()

func _mostrar_derrota():
	juego_activo = false
	pantalla_derrota.visible = true

func _reiniciar_nivel():
	sonar_click()
	get_tree().reload_current_scene()

func _ir_a_creditos():
	sonar_click()
	get_tree().change_scene_to_file("res://creditos.tscn")

func sonar_click():
	sonido_click.play()

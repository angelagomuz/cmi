extends Area2D

@onready var musica = $Sonidos/MusicaFondo
@onready var dialogo_previo = $DialogoPrevio
@onready var boton_empezar = $DialogoPrevio/NinePatchRect/BotonEmpezar
@onready var spawner = $Spawner
@onready var vitaminas_y_enemigos = $VitaminasyGarrapatas
@onready var contador_label = $UI/ContadorVitaminas
@onready var sonido_vitamina = $Sonidos/SonidoVitamina
@onready var sonido_daño = $Sonidos/SonidoDaño
@onready var sonido_click = $Sonidos/SonidoClick
@onready var vidas = [$UI/Vidas/Vida1, $UI/Vidas/Vida2, $UI/Vidas/Vida3]

@onready var pantalla_victoria = $Victoria
@onready var pantalla_derrota = $Derrota
@onready var boton_reintentar = $Derrota/BotonReintentar
@onready var boton_siguiente_nivel = $Victoria/BotonSiguienteNivel

var contador_vitaminas = 0
var vidas_restantes = 3
var juego_activo = false

func _ready():
	musica.play()
	contador_label.text = "Vitaminas: 0/10"
	spawner.process_mode = Node.PROCESS_MODE_DISABLED
	pantalla_victoria.visible = false
	pantalla_derrota.visible = false
	boton_empezar.pressed.connect(_empezar_juego)
	boton_reintentar.pressed.connect(_reiniciar_nivel)
	boton_siguiente_nivel.pressed.connect(_ir_a_nivel_3)

func _empezar_juego():
	sonido_click.play()
	dialogo_previo.visible = false
	spawner.process_mode = Node.PROCESS_MODE_INHERIT
	juego_activo = true

func subir_vitamina():
	if not juego_activo:
		return

	contador_vitaminas += 1
	contador_label.text = "Vitaminas: %d/10" % contador_vitaminas
	sonido_vitamina.play()
	print("✅ Se recogió una vitamina. Total:", contador_vitaminas)

	if contador_vitaminas >= 10:
		_mostrar_victoria()

func recibir_dano():
	if not juego_activo:
		return

	if vidas_restantes > 0:
		vidas_restantes -= 1
		vidas[vidas_restantes].visible = false
		sonido_daño.play()
		print("❌ Daño recibido. Vidas restantes:", vidas_restantes)

		if vidas_restantes == 0:
			_mostrar_derrota()

func _mostrar_victoria():
	juego_activo = false
	spawner.process_mode = Node.PROCESS_MODE_DISABLED
	pantalla_victoria.visible = true
	print("🎉 ¡Victoria!")

func _mostrar_derrota():
	juego_activo = false
	spawner.process_mode = Node.PROCESS_MODE_DISABLED
	pantalla_derrota.visible = true
	boton_reintentar.visible = true
	boton_reintentar.disabled = false
	print("💀 ¡Derrota!")

func _reiniciar_nivel():
	sonido_click.play()
	print("🔁 Reiniciando nivel...")
	get_tree().reload_current_scene()

func _ir_a_nivel_3():
	sonido_click.play()
	print("➡️ Cargando nivel 3...")
	get_tree().change_scene_to_file("res://escenas/NIVELES/nivel_3.tscn")

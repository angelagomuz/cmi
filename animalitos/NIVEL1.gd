extends Control

var preguntas = [
	{
		"texto": "¿Qué animal puede dormir de pie?",
		"opciones": ["Perro", "Gato", "Caballo"],
		"respuesta_correcta": 2
	},
	{
		"texto": "¿Qué animal utiliza la ecolocalización 
		para orientarse en la oscuridad?",
		"opciones": ["Gato", "Murciélago", "Buho"],
		"respuesta_correcta": 1
	},
	{
		"texto": "¿Qué animal puede regenerar partes completas 
		de su cuerpo, como el corazón o el cerebro?",
		"opciones": ["Salamanquesa", "Pulpo", "Axolote"],
		"respuesta_correcta": 2
	}
]

var pregunta_actual = 0
var respuestas_correctas = 0
var pastillas_clics = 0

# Referencias
@onready var dialogo = $DialogoPrevio
@onready var caja_texto = $DialogoPrevio/CajaTexto/TextoDialogo
@onready var boton_continuar = $DialogoPrevio/BotonContinuar

@onready var interfaz = $Pregunta
@onready var pregunta_label = $Pregunta/Pregunta
@onready var opciones = [
	$Pregunta/Opciones/Opcion1,
	$Pregunta/Opciones/Opcion2,
	$Pregunta/Opciones/Opcion3
]
@onready var resultado_label = $Pregunta/Resultado
@onready var siguiente_btn = $Pregunta/BotonSiguiente

@onready var musica = $MusicaFondo
@onready var fondo = $Fondo
@onready var lagrima = $Lágrima
@onready var anim_lagrima = $Lágrima/AnimationPlayer
@onready var gato = $GatoLlorando

# Sonidos
@onready var click_sound = $ClickSound
@onready var correcto_sound = $CorrectSound
@onready var error_sound = $ErrorSound
@onready var click_pastilla_sound = $UltimaPantalla/SiguienteNivel/ClickPastilla
@onready var miau_sound = $UltimaPantalla/Derrota/miaw


# Éxito
@onready var panel_final = $UltimaPantalla/SiguienteNivel
@onready var anim_personaje = $UltimaPantalla/SiguienteNivel/AnimationPlayer2
@onready var caja_texto_final = $UltimaPantalla/SiguienteNivel/CajadeTexto
@onready var boton_continuar2 = $UltimaPantalla/SiguienteNivel/CajadeTexto/BotonContinuar2
@onready var pastillas_btn = $UltimaPantalla/SiguienteNivel/Pastillas
@onready var contador_label = $UltimaPantalla/SiguienteNivel/ContadorPastillas

# Derrota (rutas corregidas)
@onready var panel_derrota = $UltimaPantalla/Derrota
@onready var anim_derrota = $UltimaPantalla/Derrota/AnimationPlayer3
@onready var boton_continuar_derrota = $UltimaPantalla/Derrota/CajadeTexto/BotonContinuar2
@onready var boton_reintentar = $UltimaPantalla/Derrota/BotonReintentar

func _ready():
	_resetear_elementos()
	musica.play()

	boton_continuar.pressed.connect(_iniciar_quiz)
	for i in range(opciones.size()):
		opciones[i].pressed.connect(func(): _verificar_respuesta(i))
	siguiente_btn.pressed.connect(_siguiente_pregunta)

	boton_continuar2.pressed.connect(_mostrar_pastillas)
	pastillas_btn.pressed.connect(_clic_pastilla)

	anim_personaje.animation_finished.connect(_animacion_terminada)
	anim_derrota.animation_finished.connect(_derrota_animacion_terminada)

	boton_continuar_derrota.pressed.connect(_mostrar_reintentar)
	boton_reintentar.pressed.connect(_reiniciar_quiz)

	musica.finished.connect(_reproducir_musica)

func _resetear_elementos():
	interfaz.visible = false
	dialogo.visible = true
	resultado_label.text = ""
	siguiente_btn.disabled = true
	pregunta_actual = 0
	respuestas_correctas = 0
	pastillas_clics = 0

	lagrima.visible = false
	anim_lagrima.stop()
	gato.visible = false

	panel_final.visible = false
	caja_texto_final.visible = false
	boton_continuar2.visible = false
	pastillas_btn.visible = false
	contador_label.visible = false

	panel_derrota.visible = false
	boton_continuar_derrota.visible = false
	boton_reintentar.visible = false
	miau_sound.stop()

	# Restaurar fondo del diálogo previo (ajusta el nombre si es otro)
	fondo.texture = preload("res://png/Galeria_4.jpg")

func _iniciar_quiz():
	click_sound.play()
	dialogo.visible = false
	interfaz.visible = true
	fondo.texture = preload("res://png/FondoNivelDef.jpg")
	gato.visible = true
	lagrima.visible = true
	anim_lagrima.play("Lagrima")
	_mostrar_pregunta()

func _mostrar_pregunta():
	var p = preguntas[pregunta_actual]
	pregunta_label.text = p["texto"]
	for i in range(3):
		opciones[i].text = p["opciones"][i]
		opciones[i].disabled = false
	resultado_label.text = ""
	siguiente_btn.disabled = true

func _verificar_respuesta(indice):
	for o in opciones:
		o.disabled = true
	var correcta = preguntas[pregunta_actual]["respuesta_correcta"]
	if indice == correcta:
		resultado_label.text = "¡Correcto!"
		correcto_sound.play()
		respuestas_correctas += 1
	else:
		resultado_label.text = "Incorrecto."
		error_sound.play()
	siguiente_btn.disabled = false
	click_sound.play()

func _siguiente_pregunta():
	click_sound.play()
	pregunta_actual += 1
	if pregunta_actual < preguntas.size():
		_mostrar_pregunta()
	else:
		_finalizar_quiz()

func _finalizar_quiz():
	interfaz.visible = false
	lagrima.visible = false
	anim_lagrima.stop()
	gato.visible = false

	if respuestas_correctas >= 2:
		panel_final.visible = true
		anim_personaje.play("SiguienteNivel")
	else:
		panel_derrota.visible = true
		anim_derrota.play("Derrota")
		miau_sound.stream.loop = true
		miau_sound.play()

func _animacion_terminada(anim_name):
	if anim_name == "SiguienteNivel":
		caja_texto_final.visible = true
		boton_continuar2.visible = true

func _derrota_animacion_terminada(anim_name):
	if anim_name == "Derrota":
		boton_continuar_derrota.visible = true

func _mostrar_pastillas():
	caja_texto_final.visible = false
	boton_continuar2.visible = false
	pastillas_btn.visible = true
	contador_label.visible = true
	contador_label.text = "0/5 pastillas"
	click_sound.play()

func _mostrar_reintentar():
	click_sound.play()
	boton_continuar_derrota.visible = false
	boton_reintentar.visible = true

func _clic_pastilla():
	if pastillas_clics < 5:
		pastillas_clics += 1
		contador_label.text = str(pastillas_clics) + "/5 pastillas"
		click_pastilla_sound.play()
		if pastillas_clics == 5:
			print("¡Pastillas completas!")
			await get_tree().create_timer(1.0).timeout  # Espera 1 segundo antes de cambiar
			get_tree().change_scene_to_file("res://escenas/NIVELES/NIVEL2.tscn")  # Ruta a tu Nivel 2

			# Aquí puedes mostrar un botón para ir al siguiente nivel

func _reiniciar_quiz():
	click_sound.play()
	miau_sound.stop()
	_resetear_elementos()
	musica.play()

func _reproducir_musica():
	musica.play()

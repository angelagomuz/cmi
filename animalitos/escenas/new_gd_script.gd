extends AudioStreamPlayer

# Rellena estos valores
var start_time = 0.0  # El segundo donde empieza el bucle
var end_time = 8.5  # El segundo donde termina el bucle
var fade_duration = 1.0# Duración del fundido (en segundos)
var fading = false  # Variable para saber si estamos en el proceso de fundido

func _ready():
	play()  # Inicia la reproducción
	seek(start_time)  # Empieza desde el segundo de inicio

func _process(_delta):
	# Revisa si el audio está sonando y si el tiempo de reproducción ha alcanzado el final de la parte seleccionada
	if playing:
		var current_position = get_playback_position()
		
		# Si estamos cerca del final de la parte del bucle, iniciamos el fundido
		if current_position >= end_time - fade_duration and not fading:
			fading = true
			# Empieza el fundido: disminuye el volumen
			var fade_step = -0.0 / fade_duration  # Reducir volumen hasta -80 dB
			self.volume_db += fade_step * _delta  # Aplica el fundido

			if self.volume_db <= -0:
				# Cuando el volumen llegue a -80 dB, reinicia el audio y vuelve a subir el volumen
				seek(start_time)  # Reinicia el audio en `start_time`
				self.volume_db = 0  # Restaura el volumen
				fading = false  # Termina el proceso de fundido
		elif current_position >= end_time:
			# Si el audio ha llegado al final de `end_time`, reinicia el audio
			seek(start_time)  # Vuelve al `start_time` sin fundido si no está haciendo fundido

extends AudioStreamPlayer


var start_time = 0.0  
var end_time = 8.5 
var fade_duration = 1.0
var fading = false  

func _ready():
	play()  
	seek(start_time)  

func _process(_delta):
	
	if playing:
		var current_position = get_playback_position()
		
		
		if current_position >= end_time - fade_duration and not fading:
			fading = true
			
			var fade_step = -0.0 / fade_duration  
			self.volume_db += fade_step * _delta  

			if self.volume_db <= -0:
				
				seek(start_time) 
				self.volume_db = 0  
				fading = false 
		elif current_position >= end_time:
			
			seek(start_time)  

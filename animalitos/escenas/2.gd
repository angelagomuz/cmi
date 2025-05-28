extends Node

@onready var animation_player: AnimationPlayer = $AnimationPlayer

func _ready():
	animation_player.play("RESET")
	animation_player.animation_finished.connect(_on_animation_finished)

func _on_animation_finished(anim_name: String) -> void:
	if anim_name == "RESET":
		var next_scene = load("res://escenas/5.tscn")
		get_tree().change_scene_to_packed(next_scene)

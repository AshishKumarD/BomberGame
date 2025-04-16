extends Node2D

func _ready():
	var audio_player = $AudioStreamPlayer2D
	audio_player.play()
	

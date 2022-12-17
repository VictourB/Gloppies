extends Node

const HURT = preload("res://Sound/sfx_hurt.wav")
const JUMP = preload("res://Sound/sfx_jump.wav")
const BIGJUMP = preload("res://Sound/sfx_bigJump.wav")
const LANDING = preload("res://Sound/sfx_landing.wav")
const SELECTION = preload("res://Sound/sfx_select.wav")
const CHECKPOINT = preload("res://Sound/sfx_checkpoint.wav")
const DOOR = preload("res://Sound/sfx_door.wav")

onready var audioPlayers = $AudioPlayers

func play_sound(sound):
	for audioStreamPlayer in audioPlayers.get_children():
		if not audioStreamPlayer.playing:
			audioStreamPlayer.stream = sound
			audioStreamPlayer.play()
			break
	




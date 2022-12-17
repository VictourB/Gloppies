extends Node

const PIXELFOREST = preload("res://Sound/Pixel Forest.wav")
const PIXELCITY = preload("res://Sound/Pixel City.wav")
const PIXELOCEAN = preload("res://Sound/Pixel Ocean.wav")
const PIXELBEAT = preload("res://Sound/PixelBeat.wav")



onready var bg__track = $AudioPlayers/BG_Track

const songs = [PIXELBEAT, PIXELFOREST, PIXELCITY, PIXELOCEAN, ]
const song_names = ["Pixel Beat","Pixel Forest", "Pixel City", "Pixel Ocean", ]
const artist_names = ["Lucilius", "Lucilius", "Lucilius", "Lucilius"]
var song_index = 0

onready var audioPlayers = $AudioPlayers

var is_playing = false

func _ready():
	pass

func _process(delta):
	if Input.is_action_just_pressed("next_track"):
		next_track()
	elif Input.is_action_just_pressed("prev_track"):
		prev_track()

func play_music(track):
	for audioStreamPlayer in audioPlayers.get_children():
		if audioStreamPlayer.playing:
			
			audioStreamPlayer.playing = false
			is_playing = false
			
		audioStreamPlayer.stream = track
		audioStreamPlayer.play()
		print(track)
		is_playing = true
		break
	
func stop_music():
	for audioStreamPlayer in audioPlayers.get_children():
		if audioStreamPlayer.playing:
			
			audioStreamPlayer.playing = false
			is_playing = false
			
		break
	
func is_playing():
	return is_playing

func start_music():
	MusicPlayer.play_music(songs[song_index])

func prev_track():
	song_index -= 1
	if song_index < 0:
		song_index = songs.size() -1
	MusicPlayer.play_music(songs[song_index])
	Events.emit_signal("track_changed")

func next_track():
	song_index += 1
	if song_index > (songs.size() -1):
		song_index = 0
	MusicPlayer.play_music(songs[song_index])
	Events.emit_signal("track_changed")

	
	

extends Control

onready var gloppie_label = $HBoxContainer/GloppieLabel
onready var track_label = $HBoxContainer2/TrackLabel
onready var animated_sprite = $HBoxContainer/AnimatedSprite
onready var artist_label = $HBoxContainer2/ArtistLabel

const GLOPPIE_NAMES = ["Triffid","Manhatten","Mr. Crisp","Qu","Odo"]

var current_song = MusicPlayer.song_names[MusicPlayer.song_index]
var current_artist = MusicPlayer.artist_names[MusicPlayer.song_index]

func _on_skin_changed():
	animated_sprite.frames = GlobalSettings.skins[GlobalSettings.gloppie_skin_index]
	gloppie_label.set("text", GLOPPIE_NAMES[GlobalSettings.gloppie_skin_index])
	
func _on_track_changed():
	current_song = MusicPlayer.song_names[MusicPlayer.song_index]
	current_artist = MusicPlayer.artist_names[MusicPlayer.song_index]
	
	track_label.set("text", current_song)
	artist_label.set("text", "by " + current_artist)



func _on_Info_ready():
	current_song = MusicPlayer.song_names[MusicPlayer.song_index]
	current_artist = MusicPlayer.artist_names[MusicPlayer.song_index]
	track_label.set("text", current_song)
	artist_label.set("text", "by " + current_artist)
	
	animated_sprite.frames = GlobalSettings.skins[GlobalSettings.gloppie_skin_index]
	gloppie_label.set("text", GLOPPIE_NAMES[GlobalSettings.gloppie_skin_index])
	Events.connect("skin_changed",self, "_on_skin_changed")
	Events.connect("track_changed",self, "_on_track_changed")

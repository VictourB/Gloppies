extends Control


onready var gloppie = $Gloppie
onready var gloppie_2 = $Gloppie2

var Options = preload("res://OptionsMenu.tscn")

onready var start_button = $VBoxContainer/StartButton


func _ready():
	start_button.grab_focus()
	if not MusicPlayer.is_playing(): 
		
		MusicPlayer.play_music(MusicPlayer.PIXELBEAT)
	
func _process(delta):
	gloppie.position.x -= 75 * delta
	if gloppie.position.x < -100:
		gloppie.position.x = 500
		
	gloppie_2.position.x += 100 * delta
	if gloppie_2.position.x > 500:
		gloppie_2.position.x = -100
	
		

func _on_StartButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	Transitions.play_exit_transition()
	yield(Transitions, "transition_completed")
	get_tree().change_scene("res://levels/Grass-2.tscn")
	#MusicPlayer.start_music()
	Transitions.play_enter_transition()


func _on_OptionsButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	var options = Options.instance()
	add_child(options)
	pass


func _on_ExitButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	get_tree().quit()



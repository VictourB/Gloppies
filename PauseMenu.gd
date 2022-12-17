extends Control

var is_paused = false setget set_is_paused

var Options = preload("res://OptionsMenu.tscn")

onready var start_button: = $CenterContainer/VBoxContainer/ContinueButton


func _unhandled_input(event):
	if event.is_action_pressed("pause"):
		SoundPlayer.play_sound(SoundPlayer.SELECTION)
		self.is_paused = !is_paused
		start_button.grab_focus()

func set_is_paused(value):
	is_paused = value
	get_tree().paused = is_paused
	visible = is_paused


func _on_ContinueButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	self.is_paused = false 


func _on_MainMenuButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	Transitions.play_exit_transition()
	yield(Transitions, "transition_completed")
	#MusicPlayer.stop_music()
	self.is_paused = false
	get_tree().change_scene("res://MainMenu.tscn")
	Transitions.play_enter_transition()


func _on_OptionsButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	var options = Options.instance()
	add_child(options)



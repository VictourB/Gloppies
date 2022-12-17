extends Control

onready var sfx_slider = $ColorRect/hBoxContainer/VBoxContainer/vBoxContainer/SFXSlider
onready var music_slider = $ColorRect/hBoxContainer/VBoxContainer/vBoxContainer2/MusicSlider


func _ready():
	$ColorRect/hBoxContainer/VBoxContainer2/ExitButton.grab_focus()
	
	sfx_slider.value = GlobalSettings.sfx_volume
	music_slider.value = GlobalSettings.music_volume

func _on_ExitButton_pressed():
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	get_parent().start_button.grab_focus()
	queue_free()



func _on_SFXSlider_value_changed(value):
	GlobalSettings.sfx_volume = value
	AudioServer.set_bus_volume_db(2, GlobalSettings.music_volume)
	SoundPlayer.play_sound(SoundPlayer.JUMP)


func _on_MusicSlider_value_changed(value):
	GlobalSettings.music_volume = value
	
	AudioServer.set_bus_volume_db(1, GlobalSettings.music_volume)


func _on_FullscreenButton_toggled(button_pressed):
	print(button_pressed)
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	GlobalSettings.fullscreen = button_pressed
	OS.window_fullscreen = GlobalSettings.fullscreen


func _on_SFXButton_toggled(button_pressed):
	print(button_pressed)
	GlobalSettings.sfx_enabled = button_pressed
	AudioServer.set_bus_mute(2, !GlobalSettings.sfx_enabled)
	SoundPlayer.play_sound(SoundPlayer.SELECTION)


func _on_MusicButton_toggled(button_pressed):
	print(button_pressed)
	GlobalSettings.music_enabled = button_pressed
	SoundPlayer.play_sound(SoundPlayer.SELECTION)
	AudioServer.set_bus_mute(1, !GlobalSettings.music_enabled)

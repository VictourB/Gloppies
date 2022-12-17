extends Node2D

const PlayerScene = preload("res://Player/player.tscn")

var player_spawn_location = Vector2.ZERO

onready var camera: = $Camera2D
onready var player: = $player
onready var timer: = $Timer

func _ready():
	VisualServer.set_default_clear_color(Color.cornflower)
	player.connect_camera(camera)
	player_spawn_location = player.global_position
	Events.connect("player_died",self, "_on_player_died")
	Events.connect("reached_checkpoint",self, "_on_reached_checkpoint")
	
func _on_player_died():
	timer.start(1.0)
	yield(timer, "timeout")
	var new_player = PlayerScene.instance()
	new_player.position = player_spawn_location
	add_child(new_player)
	
	new_player.connect_camera(camera)
	
func _on_reached_checkpoint(checkpoint_position):
	player_spawn_location = checkpoint_position

	




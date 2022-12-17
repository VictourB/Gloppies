extends Area2D


onready var animatedSprite: = $AnimatedSprite

var active = true
var has_been_checked = false

func _on_Checkpoint_body_entered(body):
	if not body is Player: return
	if not active: return
	animatedSprite.play("Checked")
	SoundPlayer.play_sound(SoundPlayer.CHECKPOINT)
	Events.emit_signal("reached_checkpoint", position)
	active = false
	

extends Area2D

onready var player_death_effect = $PlayerDeathEffect

func _on_Hitbox_body_entered(body):
	if body is Player:
		player_death_effect.global_position.x = body.position.x
		player_death_effect.global_position.y = body.position.y
		player_death_effect.emitting = true
		body.player_died()
		

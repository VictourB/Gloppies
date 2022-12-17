extends KinematicBody2D


var direction = Vector2.RIGHT
var velocity = Vector2.ZERO

onready var ledgeCheck: = $LedgeCheck

func _physics_process(delta):
	var found_wall = is_on_wall()
	var found_ledge = not ledgeCheck.is_colliding()
	
	if found_wall or found_ledge:
		direction *= -1
		scale.x = -1
	
	velocity = direction * 25
	apply_gravity()
	move_and_slide(velocity, Vector2.UP)
	
func apply_gravity():
	velocity.y += 20
	velocity.y = min(velocity.y, 300)

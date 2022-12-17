extends Node2D


enum {HOVER,FALL,LAND,RISE}

var state = HOVER

onready var start_position = global_position
onready var timer: = $Timer
onready var raycast: = $RayCast2D
onready var animatedSprite: = $AnimatedSprite
onready var particles: = $Particles2D
onready var player_raycast: = $DetectionRayCast

func _physics_process(delta):
	if player_raycast.is_colliding(): state = FALL
		 
	match state:
		HOVER: hover()
		FALL: fall(delta)
		LAND: land()
		RISE: rise(delta)

func hover():
	pass
	
func fall(delta):
	animatedSprite.play("Falling")
	position.y += 100 * delta
	if raycast.is_colliding():
		var collision_point = raycast.get_collision_point()
		position.y = collision_point.y
		state = LAND
		timer.start(1.0)
		particles.emitting = true
	
func land():
	if timer.time_left == 0:
		state = RISE
	
func rise(delta):
	animatedSprite.play("Rising")
	position.y = move_toward(position.y, start_position.y, 25*delta)
	if position.y == start_position.y:
		state = HOVER

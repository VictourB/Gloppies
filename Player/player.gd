extends KinematicBody2D
class_name Player

enum {MOVE, CLIMB,}

export(Resource) var moveData = preload("res://Player/DefaultPlayerMovementData.tres") as PlayerMovementData

var velocity = Vector2.ZERO
var state = MOVE
var double_jump = 1
var buffered_jump = false
var coyote_jump = false

onready var animatedSprite: = $AnimatedSprite
onready var ladderCheck: = $LadderCheck
onready var jumpBufferTimer: = $jumpBufferTimer
onready var coyoteJumpTimer: = $coyoteJumpTimer
onready var remoteTransform2D: = $RemoteTransform2D
onready var above_raycast = $AboveRaycast
onready var above_raycast_2 = $AboveRaycast2



func _ready():
	animatedSprite.frames = GlobalSettings.skins[GlobalSettings.gloppie_skin_index]

func _process(_delta):
	if Input.is_action_just_pressed("ui_tab"):
		if GlobalSettings.gloppie_skin_index == (GlobalSettings.skins.size() - 1):
			GlobalSettings.gloppie_skin_index = 0
		else: GlobalSettings.gloppie_skin_index += 1
		animatedSprite.frames = GlobalSettings.skins[GlobalSettings.gloppie_skin_index]
		Events.emit_signal("skin_changed")
		
		
func _physics_process(delta):
	var input = Vector2.ZERO
	input.x = Input.get_axis("ui_left", "ui_right")
	input.y = Input.get_axis("ui_up", "ui_down")
	
	match state:
		MOVE: move_state(input, delta)
		CLIMB: climb_state(input, delta)
	
func move_state(input, delta):
	if is_on_ladder() and Input.is_action_just_pressed("ui_up"):
		state = CLIMB
	
	apply_gravity(delta)
	
	if not horizontal_move(input):
		apply_friction(delta)
		animatedSprite.animation = "idle"
	else:
		apply_acceleration(input.x, delta)
		animatedSprite.animation = "run"
		animatedSprite.flip_h = input.x > 0
		if animatedSprite.flip_h:
			$Particles2D.process_material.direction.x = 20
			$Particles2D.process_material.orbit_velocity = 1
			$Particles2D.position.x = -7
		else:
			$Particles2D.process_material.direction.x = -20
			$Particles2D.process_material.orbit_velocity = -1
			$Particles2D.position.x = 7
	
	if is_on_floor():
		if Input.is_action_pressed("ui_down"):
			$CollisionShape2D2.scale.y = .6
			animatedSprite.scale.y = .85
			animatedSprite.position.y = 5
				
		elif not above_raycast.is_colliding() and not above_raycast_2.is_colliding():
			$CollisionShape2D2.scale.y = 1
			animatedSprite.scale.y = 1
			animatedSprite.position.y = 3
			
					
		reset_double_jump()
	else: 
		animatedSprite.animation = "jump"	
	
	if can_jump():
		var big_jump = false
		if Input.is_action_pressed("ui_down") and abs(velocity.x) < moveData.speed and not above_raycast.is_colliding() and not above_raycast_2.is_colliding():
			big_jump = true
		input_jump(input, big_jump)
	else:
		input_min_jump()
		input_double_jump() 
		buffer_jump()		
		fast_fall(delta)
		
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	
	velocity = move_and_slide(velocity, Vector2.UP)
	
	if self.position.y >= 400:
		player_died()
	
	var just_landed = is_on_floor() and was_in_air
	var just_left_ground = not is_on_floor() and was_on_floor
	
	if just_landed:
		if $sceneStartedTimer.time_left <= 0:
			SoundPlayer.play_sound(SoundPlayer.LANDING)
		animatedSprite.animation = "run"
		animatedSprite.frame = 1
		
	
	if just_left_ground and velocity.y >= 0:
		coyote_jump = true
		coyoteJumpTimer.start()
	
func climb_state(input, delta):
	if not is_on_ladder():
		state = MOVE
	
	if input.length() != 0:
		animatedSprite.animation = "run"
	else:
		animatedSprite.animation = "idle"
	velocity = input * moveData.climb_speed
	velocity = move_and_slide(velocity, Vector2.UP)	

func player_died():
	SoundPlayer.play_sound(SoundPlayer.HURT)
	queue_free()
	Events.emit_signal("player_died")

func connect_camera(camera):
	var camera_path = camera.get_path()
	remoteTransform2D.remote_path = camera_path

func input_min_jump():
	if Input.is_action_just_released("ui_select") and velocity.y < moveData.min_jump_height:
		velocity.y = moveData.min_jump_height
	
func input_double_jump():
	if Input.is_action_just_pressed("ui_select") and double_jump > 0:
		SoundPlayer.play_sound(SoundPlayer.JUMP)
		velocity.y = moveData.max_jump_height
		double_jump -= 1
	
func buffer_jump():
	if Input.is_action_just_pressed("ui_select"):
		buffered_jump = true
		jumpBufferTimer.start()

func fast_fall(delta):
	if velocity.y > 0 :
		velocity.y += moveData.gravity * delta
		if not above_raycast.is_colliding() and not above_raycast_2.is_colliding():
			animatedSprite.scale.y = 1
			animatedSprite.position.y = 3
			

func horizontal_move(input):
	return input.x != 0

func can_jump():
	return is_on_floor() or coyote_jump		
	
func reset_double_jump():
	double_jump = moveData.double_jump_count	
	
func input_jump(input, bj):
	if Input.is_action_just_pressed("ui_select") or buffered_jump:
		if bj == true:
			SoundPlayer.play_sound(SoundPlayer.BIGJUMP)
			velocity.y = moveData.max_jump_height * 1.5
			animatedSprite.scale.y = 1.1
			animatedSprite.position.y = 2
		else: 
			SoundPlayer.play_sound(SoundPlayer.JUMP)
			velocity.y = moveData.max_jump_height
			
			
		buffered_jump = false
			
		if abs(velocity.x) >= moveData.speed:
#			$CPUParticles2D.visible = true
			$Particles2D.emitting = true
			velocity.x += input.x * (moveData.speed * moveData.boost_factor)
			
func is_on_ladder():
	if not ladderCheck.is_colliding(): return false
	var collider = ladderCheck.get_collider()
	if not collider is Ladder: return false
	return true
	
func apply_gravity(delta):
	velocity.y += moveData.gravity * delta
	velocity.y = min(velocity.y, 300)
	
func apply_friction(delta):
	velocity.x = move_toward(velocity.x, 0, moveData.friction * delta)
	
func apply_acceleration(input_x, delta):
	velocity.x = move_toward(velocity.x, moveData.speed * input_x, moveData.acceleration * delta)

func _on_jumpBufferTimer_timeout():
	buffered_jump = false

func _on_coyoteJumpTimer_timeout():
	coyote_jump = false

	

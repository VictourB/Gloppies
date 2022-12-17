tool
extends Path2D


enum ANIMATION_TYPE {
	LOOP,
	BOUNCE
}

export(ANIMATION_TYPE) var animation_type setget set_animation_type
export(float) var speed = 1.0 setget set_speed

onready var animationPlayer = $AnimationPlayer


# Called when the node enters the scene tree for the first time.
func _ready():
	play_updated_animation(animationPlayer)


func play_updated_animation(ap):
	match animation_type:
		ANIMATION_TYPE.LOOP: ap.play("MoveAlongPath")
		ANIMATION_TYPE.BOUNCE: ap.play("MoveAlongPath (bounce)")

func set_animation_type(value):
	animation_type = value
	var ap = find_node("AnimationPlayer")
	if ap: play_updated_animation(ap)
	
func set_speed(value):
	speed = value
	var ap = find_node("AnimationPlayer")
	if ap: ap.playback_speed = speed
	
	

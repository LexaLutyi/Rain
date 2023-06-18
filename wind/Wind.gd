extends Area2D

@export var wind_power = 50
@export var frame:int = 0
@export var desrtoy_time:float = 10.
@export var loops_per_sound = 2
var wind_direction = Vector2(1, 0)
var sound_frame: int = randi_range(0, loops_per_sound)

# Called when the node enters the scene tree for the first time.
func _ready():
	$AnimatedSprite2D.frame = frame
	$DestroyTimer.start(desrtoy_time)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	if body.is_in_group("drops"):
		body.wind += wind()
	elif body.is_in_group("hero"):
		# print("enter hero ", body.wind)
		body.wind += wind()


func _on_body_exited(body):
	if body.is_in_group("drops"):
		body.wind -= wind()
	elif body.is_in_group("hero"):
		body.wind -= wind()


func _on_destroy_timer_timeout():
	queue_free()
	pass # Replace with function body.

func wind():
	return wind_direction.rotated(rotation) * wind_power


func _on_area_entered(area):
	if area.is_in_group("enemy"):
		area.wind += wind()


func _on_area_exited(area):
	if area.is_in_group("enemy"):
		area.wind -= wind()



func _on_animated_sprite_2d_animation_looped():
	sound_frame += 1
	if sound_frame == loops_per_sound:
		$AudioStreamPlayer2D.play()
		sound_frame = -1

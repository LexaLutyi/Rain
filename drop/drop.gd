extends RigidBody2D

var is_merged: bool = false
var wind: Vector2 = Vector2(0, 0)
var const_wind: Vector2 = Vector2(-5, 0)
var dim: int = 3

# Called when the node enters the scene tree for the first time.
func _ready():
	resize()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func size():
	return 0.5 * mass ** (1. / dim)

func resize():
	var r = size()
	var new_scale = Vector2.ONE * r
	for child in get_children():
		if child is Node2D:
			child.scale = new_scale

func _on_body_entered(body):
	if !body.is_in_group("drops"):
		return
	if is_merged or body.is_merged:
		return
	if body.mass > mass:
		return
	if mass > 0.32:
		return
	body.is_merged = true
	is_merged = true
	$MergeTimer.start()
	
	mass += body.mass
	resize()
	
	body.queue_free()
	

func _physics_process(delta):
	apply_central_force(wind * size())
	apply_central_force(const_wind * size())


func _on_merge_timer_timeout():
	is_merged = false
	pass # Replace with function body.

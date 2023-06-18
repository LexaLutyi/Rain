extends Area2D

var wind: Vector2 = Vector2.ZERO
var temperature: float = 1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var direction2d = (wind + Vector2(0, -1)).normalized()
	$FireAura.direction = direction2d
	update_color()
	pass

func update_color():
	var t = temperature
	var cr = 0.2 * t / (t + 1) + 0.8
	var cg = 0.7 * t / (t + 1) + 0.3
	var cb = t / (t + 1)
	$FireAura.color = Color(cr, cg, cb)

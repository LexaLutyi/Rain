extends Area2D

@export var start_heat: int = 30
var heat: int = start_heat

@export var start_health:int = 100
var health: int = start_health


var used_heat: int = 0
var created_heat: float = 0
var dying: bool = false
var scale_start: Vector2
var wind: Vector2 = Vector2.ZERO


# Called when the node enters the scene tree for the first time.
func _ready():
	health = start_health
	heat = start_heat
	$FireAnimation.play()
	scale_start = scale
	update_health(0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	heat = start_heat + start_heat *  wind.length() / (wind.length() + start_heat)
	# scale = Vector2.ONE * heat / start_heat
	
	$Health.text = var_to_str(health)
	$Heat.text = var_to_str(heat - used_heat)
	
	$Aura.scale = 1.1 * (heat - 0.5 * used_heat) * Vector2.ONE / start_heat
	$Aura.temperature = 1. * heat / 100
	$Aura.wind = wind

	var db = -30. + 5. * (heat - used_heat) / start_heat
	$FireSound.volume_db = db
	
	$HeatBar.value = 100. * (heat - used_heat) / start_heat
	$ExtraHeatBar.value = 100. * (heat - used_heat - start_heat) / start_heat
	$HealthBar.value = 100. * health / start_health
	
	update_heat(delta)
	if dying:
		scale -= scale_start * delta
	if scale < scale_start / 2:
		queue_free()
	pass


func _on_aura_body_entered(body):
	if !body.is_in_group("drops"):
		return
	vaporize_drop(body)


func _on_body_entered(body):
	if !body.is_in_group("drops"):
		return
	if !vaporize_drop(body):
		# drop is not vaporized
		var damage = roundi(body.mass * 100)
		$DamageTimer.start()
		$FireAnimation.animation = "sad"
		update_health(-damage)
	
func vaporize_drop(drop):
	var available_heat = heat - used_heat
	if available_heat <= 0:
		return false
	if drop.mass * 100 < available_heat:
		used_heat += roundi(drop.mass * 100)
		drop.queue_free()
		return true
	
	used_heat = heat
	drop.mass -= available_heat * 0.01
	drop.resize()
	return false

func update_heat(delta):
	created_heat += heat * delta
	while created_heat > 1:
		created_heat -= 1
		used_heat = max(used_heat - 1, 0)

		
func update_health(change):
	health += change
	health = max(health, 0)
	if health == 0:
		dying = true



func _on_damage_timer_timeout():
	$FireAnimation.animation = "cute"
	pass # Replace with function body.


func _on_fire_sound_finished():
	$FireSound.play()
	pass # Replace with function body.


func _on_hit_timer_timeout():
	pass # Replace with function body.

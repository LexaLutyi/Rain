extends Node2D

@export var drop_scene: PackedScene
@export var wind_scene: PackedScene
@export var enemy_scene: PackedScene
@export var score_scene: PackedScene

var dragging: bool = false
var mouse_postition_start: Vector2
var mouse_postition_end: Vector2
var enemy_position: Vector2 = Vector2(960, 530)
var enemy_health_scale = 1
var enemy_heat_scale = 1
var enemy_count = 1
var score_position = Vector2(50, 50)
var score_count = 0
var can_add_enemy: bool = true

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	var n_enemy = get_tree().get_nodes_in_group("enemy").size()
	if n_enemy == 0 and !can_add_enemy and $EnemyTimer.is_stopped():
		$EnemyTimer.start()
	elif n_enemy == 0 and can_add_enemy:
		can_add_enemy = false
		if enemy_count == 2:
			add_enemy(enemy_position + Vector2(-30, 0))
			add_enemy(enemy_position + Vector2(30, 0))
			enemy_health_scale *= 1.1
			enemy_heat_scale *= 2
			enemy_count = 1
		else:
			add_enemy(enemy_position)
			enemy_count = 2
		


func add_drop():
	var drop = drop_scene.instantiate()
	var drop_location = $DropEntry/DropEntryLocation
	drop_location.progress_ratio = randf()
	var direction = drop_location.rotation + PI / 2
	drop.position = drop_location.position
	drop.rotation = direction
	var velocity = Vector2(200, 0)
	drop.linear_velocity = velocity.rotated(drop.rotation)
	
	add_child(drop)



func _on_drop_period_timeout():
	for i in range(20):
		add_drop()


func _on_air_body_exited(body):
	body.queue_free()


func _input(event):
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT:
		# Start dragging if the click is on the sprite.
		if not dragging and event.pressed:
			mouse_postition_start = event.position
			dragging = true
		# Stop dragging if the button is released.
		if dragging and not event.pressed:
			mouse_postition_end = event.position
			add_wind(mouse_postition_start, mouse_postition_end)
			dragging = false


func add_wind(position_start, position_end):
	var wind = wind_scene.instantiate()
	wind.position = position_start
	var wind_velocity = position_end - position_start
	wind.rotate(wind_velocity.angle())
	var wind_scale = (wind_velocity.length() / wind.wind_power)
	if wind_scale > 1:
		wind_scale **= 1.5
	wind.wind_power *= wind_scale
	add_child(wind)
	

func add_enemy(pos):
	var enemy = enemy_scene.instantiate()
	enemy.position = pos
	enemy.start_health *= enemy_health_scale
	enemy.start_heat *= enemy_heat_scale
	enemy.connect("tree_exited", add_score)
	add_child(enemy)


func add_score():
	var score = score_scene.instantiate()
	score.position = score_position + Vector2(score_count * 10, 0)
	add_child(score)
	score_count += 1
	pass


func _on_enemy_timer_timeout():
	can_add_enemy = true
	pass # Replace with function body.

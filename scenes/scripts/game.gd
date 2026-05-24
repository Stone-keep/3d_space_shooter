extends Node3D

@export var laser_scene: PackedScene
@export var meteor_scene: PackedScene
@export var obstacle_scene: PackedScene
var game_size = {
	"left": -25.0,
	"right": 25.0,
	"front": -4.0,
	"back": -70.0,
}

var score := 0
const DIFFICULTY_MULTIPLIER := 1.2
const GAME_OVER_DELAY := 1.0
var game_ending := false

func _ready() -> void:
	spawn_obstacles(30, 60, game_size["front"], game_size["back"])
	Global.difficulty = 1.0
	$HUD/Control.update_difficulty(Global.difficulty)

func _on_player_shoot_laser(pos: Vector3) -> void:
	if game_ending:
		return
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.global_position = pos + Vector3(0, 0, -1.2)

func _on_meteor_timer_timeout() -> void:
	if game_ending:
		return
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)
	meteor.add_score.connect(_on_meteor_scored)

func _on_meteor_scored(points: int) -> void:
	if game_ending:
		return
	score += round(points * Global.difficulty)
	$HUD/ScoreLabel.text = "Score: %s" % score

func spawn_obstacles(amount_min: int, amount_max: int, z_min: float, z_max: float):
	if game_ending:
		return
	for i in randi_range(amount_min, amount_max):
		var obstacle = obstacle_scene.instantiate()
		$Obstacles.add_child(obstacle)
		obstacle.set_xz_position(
			randf_range(game_size["left"], game_size["right"]),
			randf_range(z_min, z_max)
		)

func _on_obstacle_timer_timeout() -> void:
	spawn_obstacles(3, 6, game_size["back"], game_size["back"] - 10)

func trigger_game_end(destroyed_by_what: String) -> void:
	if game_ending:
		return

	game_ending = true
	Global.last_score = score
	Global.destroyed_by_what = destroyed_by_what
	if score >= Global.high_score:
		Global.high_score = score

	stop_gameplay()
	await $Player.play_game_over_animation()
	await get_tree().create_timer(GAME_OVER_DELAY).timeout
	get_tree().change_scene_to_file("res://scenes/game_over.tscn")

func stop_gameplay() -> void:
	for timer in $Timers.get_children():
		timer.stop()

	for group_name in ["meteors", "obstacles", "lasers"]:
		for node in get_tree().get_nodes_in_group(group_name):
			if node.has_method("stop_moving"):
				node.stop_moving()

func _on_player_lose_health(health: int, destroyed_by_what: String) -> void:
	if health == 2:
		$HUD/Control/HBoxContainer/HealthIcon3.texture = load("res://graphics/ui/ship_health_lost_v4.png")
	elif health == 1:
		$HUD/Control/HBoxContainer/HealthIcon2.texture = load("res://graphics/ui/ship_health_lost_v4.png")
	elif health <= 0:
		$HUD/Control/HBoxContainer/HealthIcon1.texture = load("res://graphics/ui/ship_health_lost_v4.png")
		await trigger_game_end(destroyed_by_what)


func _on_difficulty_timer_timeout() -> void:
	if game_ending:
		return
	Global.difficulty *= DIFFICULTY_MULTIPLIER
	$Timers/MeteorTimer.wait_time /= DIFFICULTY_MULTIPLIER
	$Timers/MeteorTimer.start()
	$Timers/ObstacleTimer.wait_time /= DIFFICULTY_MULTIPLIER
	$Timers/ObstacleTimer.start()
	$HUD/Control.update_difficulty(Global.difficulty)
	$HUD/Control.show_difficulty_up()

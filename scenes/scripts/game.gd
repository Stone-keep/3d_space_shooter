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

func _ready() -> void:
	spawn_obstacles(30, 60, game_size["front"], game_size["back"])

func _on_player_shoot_laser(pos: Vector3) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.global_position = pos + Vector3(0, 0, -1.2)

func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	$Meteors.add_child(meteor)
	meteor.add_score.connect(_on_meteor_scored)

func _on_meteor_scored(points: int) -> void:
	score += points
	$HUD/ScoreLabel.text = "Score: %s" % score

func spawn_obstacles(amount_min: int, amount_max: int, z_min: float, z_max: float):
	for i in randi_range(amount_min, amount_max):
		var obstacle = obstacle_scene.instantiate()
		$Obstacles.add_child(obstacle)
		obstacle.set_xz_position(
			randf_range(game_size["left"], game_size["right"]),
			randf_range(z_min, z_max)
		)

func _on_obstacle_timer_timeout() -> void:
	spawn_obstacles(3, 6, game_size["back"], game_size["back"] - 10)
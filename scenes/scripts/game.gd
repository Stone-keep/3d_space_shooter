extends Node3D

@export var laser_scene: PackedScene
@export var meteor_scene: PackedScene
var score := 0

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

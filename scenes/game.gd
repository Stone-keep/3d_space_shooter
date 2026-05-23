extends Node3D

@export var laser_scene: PackedScene
@export var meteor_scene: PackedScene
@onready var meteor_positions = $Meteors/PositionMarkers.get_children()

func _on_player_shoot_laser(pos: Vector3) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.global_position = pos + Vector3(0, 0, -1.2)

func _on_meteor_timer_timeout() -> void:
	var meteor = meteor_scene.instantiate()
	var spawn_position = meteor_positions.pick_random()
	meteor.global_position = spawn_position.global_position
	$Meteors.add_child(meteor)
extends Node3D

var laser_scene: PackedScene = preload("res://scenes/laser.tscn")


func _on_player_shoot_laser(pos: Vector3) -> void:
	var laser = laser_scene.instantiate()
	$Lasers.add_child(laser)
	laser.global_position = pos + Vector3(0, 0, -1.2)
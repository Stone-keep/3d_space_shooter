extends Node3D

func _ready() -> void:
	print($Donut.mesh.material)

func _process(delta: float) -> void:
	$MeshInstance3D.rotate_x(0.3 * delta)
	$MeshInstance3D.rotate_y(0.3 * delta)
	$MeshInstance3D.rotate_z(0.3 * delta)
	$Donut.rotate_x(1 * delta)
	$Donut.position.x += 0.5 * delta
	$Donut.mesh.material.albedo_color = Color(Color.LIGHT_PINK)

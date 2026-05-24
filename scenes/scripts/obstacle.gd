extends Area3D

const SPEED := 3
var random_scale: float

func _ready() -> void:
	position.y = -2.0
	random_scale = randf_range(3.0, 5.0)
	scale = Vector3.ONE * random_scale
	rotate_y(randf_range(0, TAU))
	var meshes = $Meshes.get_children()
	var visible_mesh = meshes.pick_random()
	visible_mesh.show()

func _physics_process(delta: float) -> void:
	position.z += SPEED * delta

func set_xz_position(x: float, z: float):
	position.x = x
	position.z = z

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("hit an obstacle")
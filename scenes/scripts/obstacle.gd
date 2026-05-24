extends Area3D

const SPEED := 3
var random_scale: float

@onready var meshes := $Meshes.get_children()
@onready var collision_shapes := {
	"rock": $rock_collision,
	"rock_crystals": $rock_crystals_collision,
	"rover": $rover_collision,
	"satelliteDish": $satelliteDish_collision,
	"turret_single": $turret_single_collision,
	"turret_double": $turret_double_collision,
	"gate_complex": $gate_complex_collision,
}

func _ready() -> void:
	position.y = -2.0
	random_scale = randf_range(3.0, 5.0)
	scale = Vector3.ONE * random_scale
	rotate_y(randf_range(0, TAU))
	var visible_mesh = meshes.pick_random()

	for mesh in meshes:
		mesh.hide()
	for collision_shape in collision_shapes.values():
		collision_shape.disabled = true

	visible_mesh.show()
	collision_shapes[visible_mesh.name].disabled = false

func _physics_process(delta: float) -> void:
	position.z += SPEED * delta

func set_xz_position(x: float, z: float):
	position.x = x
	position.z = z

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.got_hit("obstacle")

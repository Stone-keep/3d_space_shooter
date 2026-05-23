extends Area3D

var speed: float
var random_scale: float
var random_rotation_speed: Vector3
var drift_x: float

var player: Node3D

func _ready() -> void:
	speed = randf_range(4.0, 6.0)
	random_scale = randf_range(1.0, 2.0)
	scale = Vector3.ONE * random_scale
	random_rotation_speed = Vector3(
	randf_range(-0.5, 0.5),
	randf_range(-0.5, 0.5),
	randf_range(-0.5, 0.5)
	)
	drift_x = randf_range(-0.5, 0.5)

func _physics_process(delta: float) -> void:
	position.z += speed * delta
	position.x += drift_x * delta
	rotation += random_rotation_speed * delta

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("lasers"):
		area.queue_free()
		queue_free()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("got hit")
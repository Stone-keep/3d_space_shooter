extends Area3D

var speed: float
var random_scale: float
var random_rotation_speed: Vector3
var drift_x: float
var can_move := true

@onready var mesh := $meteor
@onready var flash_material := mesh.material_overlay as ShaderMaterial
signal add_score(points: float)

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
	if can_move:
		position.z += speed * delta
		position.x += drift_x * delta
		rotation += random_rotation_speed * delta

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("lasers"):
		can_move = false
		add_score.emit(scale.x)
		flash()
		$meteor.material_overlay.set_shader_parameter("progress", 1.0)
		area.destroy()
		await get_tree().create_timer(0.3).timeout
		queue_free()

func flash() -> void:
	var tween := create_tween()
	tween.tween_property(flash_material, "shader_parameter/progress", 1.0, 0.1)
	tween.tween_property(flash_material, "shader_parameter/progress", 0.0, 0.2)

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		print("got hit")
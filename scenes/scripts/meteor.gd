extends Area3D

var speed: float
var random_scale: float
var random_rotation_speed: Vector3
var drift_x: float
var can_move := true
var points: int

@onready var mesh := $meteor
@onready var flash_material := mesh.material_overlay as ShaderMaterial
signal add_score(points: int)

@export var crash_sounds: Array[AudioStream]
@onready var crash_sound := $CrashSound

var player: Node3D

func _ready() -> void:
	position.z = randf_range(-70.0, -90.0)
	position.x = randf_range(-50.0, 50.0)
	speed = randf_range(4.0, 6.0) * Global.difficulty
	random_scale = randf_range(1.0, 2.0)
	scale = Vector3.ONE * random_scale
	random_rotation_speed = Vector3(
	randf_range(-0.5, 0.5),
	randf_range(-0.5, 0.5),
	randf_range(-0.5, 0.5)
	)
	drift_x = randf_range(-1, 1)
	points = roundi(random_scale * 100)

func _physics_process(delta: float) -> void:
	if can_move:
		position.z += speed * delta
		position.x += drift_x * delta
		rotation += random_rotation_speed * delta

func stop_moving() -> void:
	can_move = false

func _on_area_entered(area: Area3D) -> void:
	if area.is_in_group("lasers"):
		can_move = false
		add_score.emit(points)
		play_crash_sound()
		flash()
		$meteor.material_overlay.set_shader_parameter("progress", 1.0)
		area.destroy()
		await get_tree().create_timer(0.3).timeout
		queue_free()

func flash() -> void:
	var tween := create_tween()
	tween.tween_property(flash_material, "shader_parameter/progress", 1.0, 0.1)
	tween.tween_property(flash_material, "shader_parameter/progress", 0.0, 0.2)

func play_crash_sound():
	crash_sound.stream = crash_sounds.pick_random()
	crash_sound.play()

func _on_body_entered(body: Node3D) -> void:
	if body.is_in_group("player"):
		body.got_hit("meteor")

func _on_visible_on_screen_notifier_3d_screen_exited() -> void:
	queue_free()

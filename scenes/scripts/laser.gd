extends Area3D

const SPEED = 10
var can_move := true

@onready var mesh := $Red
@onready var flash_material := mesh.material_overlay as ShaderMaterial

func _ready() -> void:
	scale = Vector3(0.01, 0.01, 0.01)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, 0.3)

func _physics_process(delta: float) -> void:
	if can_move:
		position.z -= SPEED * delta
	if position.z <= -150:
		queue_free()

func flash() -> void:
	var tween := create_tween()
	tween.tween_property(flash_material, "shader_parameter/progress", 1.0, 0.1)
	tween.tween_property(flash_material, "shader_parameter/progress", 0.0, 0.2)

func destroy():
	can_move = false
	flash()
	await get_tree().create_timer(0.3).timeout
	queue_free()
extends Area3D

const SPEED = 10

func _ready() -> void:
	scale = Vector3(0.01, 0.01, 0.01)
	var tween = create_tween()
	tween.tween_property(self, "scale", Vector3.ONE, 0.3)

func _physics_process(delta: float) -> void:
	position.z -= SPEED * delta
	if position.z <= -150:
		queue_free()
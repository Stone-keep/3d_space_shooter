extends CharacterBody3D

const SPEED = 10.0
var direction := 0.0

var can_shoot := true

signal shoot_laser(pos: Vector3)

func _physics_process(delta: float) -> void:
	direction = Input.get_axis("left", "right")
	velocity.x = direction * SPEED
	$craft_speederC.rotation.z = move_toward($craft_speederC.rotation.z, -0.5 * direction, delta)
	velocity.y = sin(Time.get_ticks_msec() / 1000.0) / 4.0 + sin(Time.get_ticks_msec() / 800.0) / 9.0
	move_and_slide()
	shoot()

func shoot():
	if Input.is_action_just_pressed("shoot"):
		if can_shoot:
			can_shoot = false
			$ShootCooldown.start()
			shoot_laser.emit(global_position)

func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true
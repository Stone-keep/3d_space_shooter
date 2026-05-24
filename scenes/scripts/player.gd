extends CharacterBody3D

const SPEED = 10.0
var direction := 0.0
var health := 3

var can_shoot := true
var can_control := true
var invulnerable := false

signal shoot_laser(pos: Vector3)
signal lose_health(health: int, destroyed_by_what: String)

func _ready() -> void:
	invulnerable = true
	$InvulnerabilityTimer.start()
	flash_invulnerability()

func _physics_process(delta: float) -> void:
	if not can_control:
		velocity = Vector3.ZERO
		move_and_slide()
		return

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

func flash_invulnerability() -> void:
	var tween := create_tween()
	tween.set_loops(5)
	tween.tween_property($craft_speederC, "transparency", 0.7, 0.3)
	tween.tween_property($craft_speederC, "transparency", 0.2, 0.3)
	await tween.finished
	$craft_speederC.transparency = 0.0

func _on_shoot_cooldown_timeout() -> void:
	can_shoot = true

func got_hit(destroyed_by_what: String):
	if not invulnerable:
		invulnerable = true
		$InvulnerabilityTimer.start()
		$CollisionSound.play()
		health -= 1
		lose_health.emit(health, destroyed_by_what)
		if health > 0:
			flash_invulnerability()

func _on_invulnerability_timer_timeout() -> void:
	invulnerable = false

func stop_for_game_over() -> void:
	can_control = false
	can_shoot = false
	velocity = Vector3.ZERO
	$ShootCooldown.stop()
	$InvulnerabilityTimer.stop()

func play_game_over_animation() -> void:
	stop_for_game_over()
	var tween := create_tween()
	tween.set_parallel()
	tween.tween_property($craft_speederC, "scale", Vector3.ONE * 1.45, 0.25)
	tween.tween_property($craft_speederC, "transparency", 1.0, 0.45)
	tween.tween_property($craft_speederC, "rotation:z", $craft_speederC.rotation.z + 1.5, 0.45)
	await tween.finished

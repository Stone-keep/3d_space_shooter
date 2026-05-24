extends Control

func _ready() -> void:
	if Global.destroyed_by_what == "meteor":
		$VBoxContainer/DestroyedBy.text = "Your ship was destroyed by a meteor!"
	elif Global.destroyed_by_what == "obstacle":
		$VBoxContainer/DestroyedBy.text = "Your ship crashed into an obstacle!"
	$VBoxContainer/Score.text = "Score:\n%s" % Global.last_score
	$VBoxContainer/HighScore.text = "High Score:\n%s" % Global.high_score
	var difficulty_percent := ceili((Global.difficulty - 1.0) * 100.0)
	$VBoxContainer/DifficultyModifier.text = "Final Difficulty Modifier: +%d%%" % difficulty_percent

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("restart"):
		get_tree().change_scene_to_file("res://scenes/game.tscn")
	elif Input.is_action_just_pressed("quit"):
		get_tree().quit()
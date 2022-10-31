extends CanvasLayer

func _process(delta):
	$GameOverScreen/ScoreData.text = str(Globals.score)

func set_game_over_panel_visibility(value):
	for child in $GameOverScreen.get_children():
		if child.name == "NewHighScore":
			continue
		child.visible = value

func _on_RestartButton_pressed():
	SignalManager.emit_signal("reset_game")

func _on_MainMenuButton_pressed():
	get_tree().change_scene("res://scenes/MainMenu.tscn")

extends Node

export(PackedScene) var platform
export var platform_y_distance = 200

var platforms_spawned = 0
var INITIAL_PLATFORM_COUNT = 6

var original_player_position = Vector2()
var player = null

var scoreLabel

func _ready():
	randomize()
		
	SignalManager.connect("create_new_platform", self, "spawn_platform")
	SignalManager.connect("add_score", self, "add_score")
	SignalManager.connect("player_death", self, "handle_player_death")
	SignalManager.connect("reset_game", self, "reset_game")

	scoreLabel = $HUD/Score

	for i in range(INITIAL_PLATFORM_COUNT):
		spawn_platform()
		
	player = $Player
	original_player_position = player.position

var music_debounce = false

func _process(delta):
	if not Globals.player_dead:
		if Globals.score >= 1 and not music_debounce:
			$Music.play()
			music_debounce = true
	else:
		$Music.stop()
	
func spawn_platform():	
	var platform_clone = platform.instance()
	var new_x = rand_range(0.0, 320.0)
	var new_y = float(560 - (platform_y_distance * platforms_spawned))
	var new_position = Vector2(new_x, new_y)
	
	platform_clone.position = new_position
	
	$Platforms.add_child(platform_clone)

	platforms_spawned += 1

	# print("Platform ", str(platforms_spawned) ," spawned")
	
func add_score():
	Globals.score += 1
	
	scoreLabel.text = str(Globals.score)
	print("Score: ", str(Globals.score))

func handle_player_death():
	Globals.player_dead = true
	Globals.camera.shake(10.0, 3.0)
	
	yield(get_tree().create_timer(1.0), "timeout")

	if Globals.score > Globals.high_score:
		Globals.high_score = Globals.score
		$HUD/GameOverScreen/NewHighScore.visible = true
		$HUD/HighScoreTune.play()
		print("New high score! ", str(Globals.high_score))
		
		Globals.save_high_score()
		
	$HUD/GameOverScreen/HighScoreData.text = str(Globals.high_score)

	$HUD.set_game_over_panel_visibility(true)

func reset_game():
	Globals.score = 0 
	Globals.player_dead = false
	scoreLabel.text = str(Globals.score)
	
	get_tree().reload_current_scene()
	
	print("Resetted Game")

extends Node

# GLOBAL VARIABLES
var score = 0
var high_score = 0
var player_dead = false
var camera = null
var announcer = null

const SAVE_FILE_PATH = "user://savedata.save"

func _ready():
	load_high_score()

func save_high_score():
	var save_data = File.new()
	save_data.open(SAVE_FILE_PATH, File.WRITE)
	save_data.store_var(high_score)
	save_data.close()
	
	print("Saved")
	
func load_high_score():
	var save_data = File.new()
	if save_data.file_exists(SAVE_FILE_PATH):
		save_data.open(SAVE_FILE_PATH, File.READ)
		high_score = save_data.get_var()
		save_data.close()
	else:
		save_high_score()
		
	print("Loaded save")
	

extends Node

const SKY_POSITION = Vector2(256, 173)

export var sky_speed = 5.0

var sky_1 = null
var sky_2 = null

func _ready():
	sky_1 = $Skies/Sky
	sky_2 = $Skies/Sky2

func _physics_process(delta):
	for sky in $Skies.get_children():
		sky.position += Vector2.DOWN * sky_speed * delta

func move_sky_on_top(a, b):
	a.position = b.position - Vector2(0.0, 1170.0) 

func _on_1st_notifier_screen_exited():
	# $Skies/Sky.position = SKY_POSITION
	move_sky_on_top(sky_1, sky_2)
	
func _on_2nd_notifier_screen_exited():
	# $Skies/Sky2.position = SKY_POSITION
	move_sky_on_top(sky_2, sky_1)


func _on_Play_pressed():
	get_tree().change_scene("res://scenes/MainScene.tscn")
		
func _on_About_pressed():
	pass # Replace with function body.

func _on_Quit_pressed():
	get_tree().quit()


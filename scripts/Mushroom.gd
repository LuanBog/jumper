extends Area2D

export var bounce_height = 1800.0

func bounce_player(player):
	player.velocity.y = -bounce_height
	Globals.camera.shake(4.0, 6.0)
	$Bounce.play()

func _on_Mushroom_body_entered(body):
	if body.name == "Player":
		bounce_player(body)

extends KinematicBody2D

export var starting_rise_level = 250.0
export var second_rise_level = 280.0
export var third_rise_level = 300.0
export var fourth_rise_level = 320.0
export var fifth_rise_level = 360.0
var rise_level = 0.0
var velocity = Vector2()

var first_debounce = false
var second_debounce = false
var third_debounce = false
var fourth_debounce = false
var fifth_debounce = false

var player = null

func _ready():
	player = self.get_parent().get_node("Player")

func _process(delta):
	if Globals.player_dead:
		rise_level = lerp(rise_level, 0.0, 0.025)
		return

	# First Stage
	if Globals.score == 14:
		self.position.y = player.position.y + 250.0
	if Globals.score >= 15 and Globals.score <= 48:
		rise_level = starting_rise_level
		
		if not first_debounce:
			Globals.announcer.announce("Lava starts rising!")
			first_debounce = true

	# Second Stage
	if Globals.score == 49:
		self.position.y = player.position.y + 250.0
	if Globals.score >= 50 and Globals.score <= 98:
		rise_level = second_rise_level

		if not second_debounce:
			Globals.announcer.announce("Lava is getting faster...")
			second_debounce = true

	# Third Stage
	if Globals.score == 99:
		self.position.y = player.position.y + 250.0
	if Globals.score >= 100 and Globals.score <= 198:
		rise_level = third_rise_level

		if not third_debounce:
			Globals.announcer.announce("AND FASTER!!!")
			third_debounce = true

	# Fourth Stage
	if Globals.score == 199:
		self.position.y = player.position.y + 350.0
	if Globals.score >= 200 and Globals.score <= 498:
		rise_level = fourth_rise_level

		if not fourth_debounce:
			Globals.announcer.announce("I CAN FEEL IT GETTING CLOSER!!!")
			fourth_debounce = true

	# Fourth Stage
	if Globals.score == 499:
		self.position.y = player.position.y + 350.0
	if Globals.score >= 500:
		rise_level = fifth_rise_level

		if not fifth_debounce:
			Globals.announcer.announce("You're going to die sooner or later...")
			fifth_debounce = true

func _physics_process(_delta):
	velocity.y = -rise_level
	
	velocity = self.move_and_slide(velocity, Vector2.UP)

func _on_Area2D_body_entered_e(body):
	if body.name == "Player":
		body.death()

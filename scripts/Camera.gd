extends Camera2D

# export var random_shake_strength = 30.0
onready var rand = RandomNumberGenerator.new()
var shake_strength = 0.0
var shake_decay_rate = 0.0

var CAMERA_Y_OFFSET = 150.0

var player = null

func _ready():
	Globals.camera = self
	
	rand.randomize()
	player = get_parent().get_node("Player")

func _process(delta):
	self.position.y = player.position.y

	shake_strength = lerp(shake_strength, 0, shake_decay_rate * delta)
	self.offset = get_random_offset()

func shake(strength : float, decay_rate=5.0):
	shake_decay_rate = decay_rate
	shake_strength = strength

func get_random_offset():
	return Vector2(
		rand.randf_range(-shake_strength, shake_strength),
		rand.randf_range(-shake_strength, shake_strength)
	) - Vector2(0.0, CAMERA_Y_OFFSET)
	

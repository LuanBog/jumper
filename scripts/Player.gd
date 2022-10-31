extends KinematicBody2D

var screen_size

# Movement variables
export var movement_speed = 400
export var jump_height = 65
export var time_jump_apex = 0.35
export var dash_down_force = 1000
var dashing_down = false
var jump_force
var gravity
var velocity = Vector2()

var animation_player

var can_control = true

func _ready():
	screen_size = OS.get_window_size()
	animation_player = $AnimationPlayer
	
func _physics_process(delta):	
	if Globals.player_dead:
		return

	self.position.x = clamp(self.position.x, 60.0, screen_size.x)
	
	gravity = (2 * jump_height) / pow(time_jump_apex, 2)
	jump_force = gravity * time_jump_apex
	velocity.y += gravity * delta
	
	if can_control:
		if Input.is_action_pressed("move_left"):
			velocity.x = -movement_speed
			if self.is_on_floor():
				animation_player.current_animation = "running"
			set_flip_of_sprites(true)
		elif Input.is_action_pressed("move_right"):
			velocity.x = movement_speed
			if self.is_on_floor():
				animation_player.current_animation = "running"
			set_flip_of_sprites(false)
		else:
			velocity.x = 0
	
		if Input.is_action_just_pressed("jump") and self.is_on_floor():
			$Jump.play()
			jump(jump_force)
		
		if Input.is_action_just_pressed("move_down") and not self.is_on_floor():
			velocity.y = dash_down_force			
			dashing_down = true

	if not self.is_on_floor():
		if velocity.y < 0:
			animation_player.current_animation = "jumping"
		else:
			animation_player.current_animation = "falling"

	if dashing_down:
		self.scale.y = lerp(self.scale.y, 1.4, 0.3)
	else:
		self.scale.y = lerp(self.scale.y, 1, 0.4)

	if self.is_on_floor():
		animation_player.current_animation = "idle"
		dashing_down = false

	velocity = self.move_and_slide(velocity, Vector2.UP)

func jump(force):
	velocity.y = -force
	animation_player.current_animation = "jumping"
	
func death():
	can_control = false
	
	self.visible = false
	$Death.play()

	SignalManager.emit_signal("player_death")

func set_flip_of_sprites(value):
	$Idle.flip_h = value
	$Running.flip_h = value
	$Jumping.flip_h = value
	$Falling.flip_h = value

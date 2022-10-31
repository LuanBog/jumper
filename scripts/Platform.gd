extends StaticBody2D

var spawned_debounce = false
var player_touch_debounce = false

export(PackedScene) var mushroom
export(PackedScene) var spike

var object_chance_min = 900
var object_chance_max = 1000
var objects = []
var OBJECT1_POS = Vector2(38.0, 1.0)
var OBJECT2_POS = Vector2(78.0, 1.0)
var OBJECT3_POS = Vector2(124.0, 1.0)

func _ready():
	randomize()

	objects = [mushroom]

	# Spikes can spawn now
	if Globals.score >= 50:
		objects.append(spike)

	if Globals.score >= 20:
		var num_chosen = randi() % object_chance_max + 1

		if num_chosen >= object_chance_min and num_chosen <= object_chance_max:
			var object_chosen = objects[randi() % objects.size()]

			spawn_object(object_chosen)

func spawn_object(object):
	var object_clone = object.instance()
	var object_position_index = randi() % 3
	var new_position = Vector2()

	match object_position_index:
		0:
			new_position = OBJECT1_POS
		1:
			new_position = OBJECT2_POS
		_:
			new_position = OBJECT3_POS

	object_clone.position = new_position
	self.add_child(object_clone)

func _on_VisibilityNotifier2D_screen_exited():
	if spawned_debounce:
		return
	
	SignalManager.emit_signal("create_new_platform")
	spawned_debounce = true

func _on_PlayerDetector_body_entered(body):
	if player_touch_debounce:
		return
	
	if body.name == "Player":
		SignalManager.emit_signal("add_score")
		player_touch_debounce = true

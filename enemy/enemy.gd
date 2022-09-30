class_name Enemy
extends RigidBody2D

const WALK_SPEED = 50

enum State {
	WALKING, #roaming
	DYING,
	CHASING,
}

var state = State.WALKING

var direction = -1
var anim = ""

var Bullet = preload("res://player/bullet.gd")
var Player = preload("res://player/player.gd")

onready var rc_left = $RaycastLeft
onready var rc_right = $RaycastRight
onready var rc_wall_left = $RayCastWallLeft
onready var rc_wall_right = $RayCastWallRight

var rng = RandomNumberGenerator.new() #used for random item spawnsz

var Book = preload("res://items/Book.gd")
var Eye = preload("res://items/Eye.gd")
var Hammer = preload("res://items/Hammer.gd")
var Pickup = preload("res://items/Pickup.tscn")
var item_dict_obj = {0: Eye, 1: Hammer, 2: Book}

func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var new_anim = anim

	if state == State.DYING:
		new_anim = "explode"
	elif state == State.WALKING:
		new_anim = "walk"

		var wall_side = 0.0

		for i in range(s.get_contact_count()):
			var cc = s.get_contact_collider_object(i)
			var dp = s.get_contact_local_normal(i)
			if cc:
				if cc is Player:
					Player._take_Damage()
					if ResourceLoader.exists("res://Scenes/replay.tscn"):
						var _error = get_tree().change_scene("res://Scenes/replay.tscn")
					else:
						get_tree().change_scene("res://Scenes/replay.tscn")
				if cc is Book or cc is Hammer or cc is Eye:
					# enqueue call
					spawn_item()
					call_deferred("_bullet_collider", cc, s, dp)
					break
			if dp.x > 0.9:
				wall_side = 1.0
			elif dp.x < -0.9:
				wall_side = -1.0
		if wall_side != 0 and wall_side != direction:
			direction = -direction
			($Sprite as Sprite).scale.x = -direction
		if direction < 0 and not rc_left.is_colliding() and rc_right.is_colliding():
			direction = -direction
			($Sprite as Sprite).scale.x = -direction
		elif direction > 0 and not rc_right.is_colliding() and rc_left.is_colliding():
			direction = -direction
			($Sprite as Sprite).scale.x = -direction
		lv.x = direction * WALK_SPEED
	elif state == State.CHASING:
		new_anim = "walk"
			
		for i in range(s.get_contact_count()):
			var cc = s.get_contact_collider_object(i)
			var dp = s.get_contact_local_normal(i)
			if cc is Player:
				call_deferred(Player._take_Damage())
				if ResourceLoader.exists("res://Scenes/replay.tscn"):
					var _error = get_tree().change_scene("res://Scenes/replay.tscn")
				else:
					get_tree().change_scene("res://Scenes/replay.tscn")
			if cc:
				if cc is Book or cc is Eye or cc is Hammer:
					# enqueue call
					spawn_item()
					call_deferred("_bullet_collider", cc, s, dp)
					break
					

			
		var motion = Vector2.ZERO
		var pos = get_position()
		motion += pos.direction_to(Player.position)
		lv.x = motion.x * WALK_SPEED
			
		if rc_wall_left.is_colliding():
			lv.y = -250
			lv.x = 10 * -WALK_SPEED
		elif rc_wall_right.is_colliding():
			lv.y = -250
			lv.x = 10 * WALK_SPEED


			


	if anim != new_anim:
		anim = new_anim
		($AnimationPlayer as AnimationPlayer).play(anim)

	s.set_linear_velocity(lv)


func _die():
	queue_free()


func _pre_explode():
	#make sure nothing collides against this
	$Shape1.queue_free()
	$Shape2.queue_free()
	$Shape3.queue_free()

	# Stay there
	mode = MODE_STATIC
	($SoundExplode as AudioStreamPlayer2D).play()


func _bullet_collider(cc, s, dp):
	mode = MODE_RIGID
	state = State.DYING

	s.set_angular_velocity(sign(dp.x) * 33.0)
	physics_material_override.friction = 1
	cc.disable()
	($SoundHit as AudioStreamPlayer2D).play()
	
#DEBUG ONLY!!
func _process(delta):
	#target player
	if (Input.is_key_pressed(KEY_J)):
		state = State.CHASING

func spawn_item():
	#get random item to add
	rng.randomize()
	var i = rng.randi_range(0, 2)
	var e = Pickup.instance()
	e.init(i)
	e.position = get_position()
	get_parent().add_child(e)

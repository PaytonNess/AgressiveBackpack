class_name Player
extends RigidBody2D

const WALK_ACCEL = 200.0
const WALK_DEACCEL = 500.0
const WALK_MAX_VELOCITY = 140.0
const AIR_ACCEL = 50.0
const AIR_DEACCEL = 70.0
const JUMP_VELOCITY = 400
const STOP_JUMP_FORCE = 450.0
const MAX_SHOOT_POSE_TIME = 0.3
const MAX_FLOOR_AIRBORNE_TIME = 0.15

var anim = ""
var siding_left = false
var jumping = false
var stopping_jump = false
var shooting = false
onready var rollRayCast = get_node("rollRay")
onready var time = get_node("Timer")
var floor_h_velocity = 0.0

var airborne_time = 1e20
var shoot_time = 1e20
var canTakeDamage = false

var Bullet = preload("res://player/Bullet.tscn")
var Enemy = preload("res://enemy/Enemy.tscn")
var canDash = false; 
onready var sound_jump = $SoundJump
onready var sound_shoot = $SoundShoot
onready var sprite = $Sprite
onready var sprite_smoke = sprite.get_node(@"Smoke")
onready var animation_player = $AnimationPlayer
onready var bullet_shoot = $BulletShoot

onready var inventory = get_tree().get_root().find_node("Inventory", true, false)
onready var heart1 = get_tree().get_root().find_node("Heart1", true, false)
onready var heart2 = get_tree().get_root().find_node("Heart2", true, false)
onready var heart3 = get_tree().get_root().find_node("Heart3", true, false)
var health = 3
func _integrate_forces(s):
	var lv = s.get_linear_velocity()
	var step = s.get_step()

	var new_anim = anim
	var new_siding_left = siding_left

	# Get player input.
	var move_left = Input.is_action_pressed("move_left")
	var move_right = Input.is_action_pressed("move_right")
	var jump = Input.is_action_pressed("jump")
	var shoot = Input.is_action_pressed("shoot")
	var spawn = Input.is_action_pressed("spawn")

	if spawn:
		call_deferred("_rolling")

	# Deapply prev floor velocity.
	lv.x -= floor_h_velocity
	floor_h_velocity = 0.0

	# Find the floor (a contact with upwards facing collision normal).
	var found_floor = false
	var floor_index = -1

	for x in range(s.get_contact_count()):
		var ci = s.get_contact_local_normal(x)

		if ci.dot(Vector2(0, -1)) > 0.6:
			found_floor = true
			floor_index = x

	# A good idea when implementing characters of all kinds,
	# compensates for physics imprecision, as well as human reaction delay.
	if shoot and not shooting and inventory.has_item():
		inventory.throw_item()
		#call_deferred("_shot_bullet")
	else:
		shoot_time += step

	if found_floor:
		airborne_time = 0.0
	else:
		airborne_time += step # Time it spent in the air.

	var on_floor = airborne_time < MAX_FLOOR_AIRBORNE_TIME

	# Process jump.
	if jumping:
		if lv.y > 0:
			# Set off the jumping flag if going down.
			jumping = false
		elif not jump:
			stopping_jump = true

		if stopping_jump:
			lv.y += STOP_JUMP_FORCE * step

	if on_floor:
		# Process logic when character is on floor.
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= WALK_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += WALK_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= WALK_DEACCEL * step
			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		# Check jump.
		if not jumping and jump:
			lv.y = -JUMP_VELOCITY
			jumping = true
			stopping_jump = false
			sound_jump.play()

		# Check siding.
		if lv.x < 0 and move_left:
			new_siding_left = true
		elif lv.x > 0 and move_right:
			new_siding_left = false
		if jumping:
			new_anim = "jumping"
		elif abs(lv.x) < 0.1:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "idle_weapon"
			else:
				new_anim = "idle"
		else:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "run_weapon"
			else:
				new_anim = "run"
	else:
		# Process logic when the character is in the air.
		if move_left and not move_right:
			if lv.x > -WALK_MAX_VELOCITY:
				lv.x -= AIR_ACCEL * step
		elif move_right and not move_left:
			if lv.x < WALK_MAX_VELOCITY:
				lv.x += AIR_ACCEL * step
		else:
			var xv = abs(lv.x)
			xv -= AIR_DEACCEL * step

			if xv < 0:
				xv = 0
			lv.x = sign(lv.x) * xv

		if lv.y < 0:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "jumping_weapon"
			else:
				new_anim = "jumping"
		else:
			if shoot_time < MAX_SHOOT_POSE_TIME:
				new_anim = "falling_weapon"
			else:
				new_anim = "falling"

	# Update siding.
	
	if new_siding_left != siding_left:
		if new_siding_left:
			sprite.scale.x = -1
			rollRayCast.scale.x = -1
		else:
			sprite.scale.x = 1
			rollRayCast.scale.x = 1
		siding_left = new_siding_left

	# Change animation.
	if new_anim != anim:
		anim = new_anim
		animation_player.play(anim)

	shooting = shoot

	# Apply floor velocity.
	if found_floor:
		floor_h_velocity = s.get_contact_collider_velocity_at_position(floor_index).x
		lv.x += floor_h_velocity

	# Finally, apply gravity and set back the linear velocity.
	lv += s.get_total_gravity() * step
	s.set_linear_velocity(lv)


func _shot_bullet():
	shoot_time = 0
	var bi = Bullet.instance()
	var ss
	if siding_left:
		ss = -1.0
	else:
		ss = 1.0
	var pos = position + bullet_shoot.position * Vector2(ss, 1.0)

	bi.position = pos
	get_parent().add_child(bi)

	bi.linear_velocity = Vector2(400.0 * ss, -40)

	sprite_smoke.restart()
	sound_shoot.play()

	add_collision_exception_with(bi) # Make bullet and this not collide.
	
func throw_object(bi):
	#Takes instance of object being thrown
	
	shoot_time = 0
	#var bi = Bullet.instance()
	var ss
	if siding_left:
		ss = -1.0
	else:
		ss = 1.0
	var pos = position + bullet_shoot.position * Vector2(ss, 1.0)

	bi.position = pos
	get_parent().add_child(bi)

	bi.linear_velocity = Vector2(400.0 * ss, -40)
	sound_shoot.play()

	add_collision_exception_with(bi) # Make bullet and this not collide.


func _spawn_enemy_above():
	var e = Enemy.instance()
	e.position = position + 50 * Vector2.UP
	get_parent().add_child(e)

func _rolling():
	var rollPosition = get_position()
	if canDash:
		if (not rollRayCast.is_colliding()):
			if siding_left:
				self.position = Vector2(rollPosition.x - 75.0, rollPosition.y)
			else:
				self.position = Vector2(rollPosition.x + 75.0, rollPosition.y)
			canDash = false
			time.set_wait_time(3.0)
	


func _on_Timer_timeout():
	canDash = true
	canTakeDamage = true

func _take_Damage():
	if canTakeDamage:
		if health == 3:
			health = 2
			heart1.enabled(false)
		if health == 2:
			health = 1
			heart2.enabled(false)
		if health == 1:
			heart3.enabled(false)
			health = 0
		time.set_wait_time(3.0)

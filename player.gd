extends CharacterBody2D

@export var player_id: int
@export var frames: SpriteFrames
@export var attack_sound: AudioStream

signal player_hit(player, from_entity, damage)

var left
var right
var jump
var attack
var lives := 6
var saved_direction = 1
var invincible = false
var damage = 1
const SPEED = 500.0
const JUMP_VELOCITY = -1200.0
const ACCELERATION = 100
const FRICTION = 20
const GRAVITY_SCALE = 3

# animation states
var attack2_playing = false
var hurt_playing = false

func _ready() -> void:
	left = "p" + str(player_id) + "_left"
	right = "p" + str(player_id) + "_right"
	jump = "p" + str(player_id) + "_jump"
	attack = "p" + str(player_id) + "_attack"
	
	$AnimatedSprite2D.sprite_frames = frames
	$AttackSound.stream = attack_sound
	
	$Slot.player = self


func _physics_process(delta: float) -> void:	
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta * GRAVITY_SCALE
	
	# Handle jump.
	if Input.is_action_just_pressed(jump) and is_on_floor():
		velocity.y = JUMP_VELOCITY
	
	# Handle left and right movement
	var direction := Input.get_axis(left, right)
	# Setting player hitbox direction
	if saved_direction != direction and direction != 0:
		saved_direction = direction
		$"AttackArea/CollisionShape2D".position.x *= -1
		$AnimatedSprite2D.flip_h = !$AnimatedSprite2D.flip_h
	
	if direction:
		velocity.x = move_toward(velocity.x, SPEED * direction, ACCELERATION)
		if attack2_playing != true and hurt_playing != true:
			$AnimatedSprite2D.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION)
		if attack2_playing != true and hurt_playing != true:
			$AnimatedSprite2D.play("idle")
	
	move_and_slide()
	
	# When attack is pressed, if there is a player in the attack area, send a signal 
	if Input.is_action_just_pressed(attack):
		if !attack2_playing:
			attack2_playing = true
			$AnimatedSprite2D.play("attack2")
			$AttackSound.play()


func check_hit():
	for body in $AttackArea.get_overlapping_bodies():
		if body is CharacterBody2D and body != self:
			player_hit.emit(body, self.global_position.x, self.damage)


func start_invincibility(dur):
	invincible = true
	$AnimatedSprite2D.modulate.a = 0.4
	$InvincibilityTimer.start(dur)


func _on_invincibility_timer_timeout() -> void:
	invincible = false
	$AnimatedSprite2D.modulate.a = 1


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "attack2":
		attack2_playing = false
		$AnimatedSprite2D.play("idle")
	elif $AnimatedSprite2D.animation == "hurt":
		hurt_playing = false
		$AnimatedSprite2D.play("idle")


func play_hurt_animation():
	$AnimatedSprite2D.play("hurt")
	hurt_playing = true


func _on_animated_sprite_2d_frame_changed() -> void:
	if $AnimatedSprite2D.animation == "attack2" and $AnimatedSprite2D.frame == 3:
		check_hit()


func knockback(diff):
	velocity.x = 300 * sign(diff)

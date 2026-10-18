extends Node

var respawn_point := Vector2(537, 75)
const KNOCKBACK_VELOCITY = 400

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	$Player1.player_hit.connect($"."._on_player_hit)
	$Player2.player_hit.connect($"."._on_player_hit)
	$LightningSpawner.player_hit.connect($"."._on_player_hit)
	$Player1/Slot.spin_result.connect($"."._on_spin_result)
	$Player2/Slot.spin_result.connect($"."._on_spin_result)
	
	$Player1/Slot.position = Vector2(0,0)
	$Player2/Slot.position = Vector2(900,0)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	$HUD.display_current_time($GameTimer.get_time_left())


# When the player dies, check if they lose a life and respawn, or game ends
func lose_life(body, from_x, damage) -> void:
	if body is CharacterBody2D:
		if body.invincible == false:
			body.lives -= damage
			$HUD.on_lives_changed(body.name, body.lives)
			body.play_hurt_animation()
			body.knockback(body.global_position.x - from_x)
			
			# If no more lives, end game, else respawn
			if body.lives <= 0:
				# End the game with the Win Screen
				get_tree().paused = true
				$WinMenu.visible = true
				if body.name == "Player1":
					$WinMenu/Label.text = "Player 2 Wins!"
				elif body.name == "Player2":
					$WinMenu/Label.text = "Player 1 Wins!"
			else:
				# Respawn the player
				# body.position = respawn_point
				body.start_invincibility(2)


# When time runs out, start the lighting overtime.
func _on_game_timer_timeout() -> void:
	$LightningSpawner.start_interval_timer()


func _on_player_hit(player, from_x, damage):
	lose_life(player, from_x, damage)


func _on_spin_result(player, symbol, count):
	if symbol == "❤️":
		if count == 2:
			player.lives += 2
			$HUD.on_lives_changed(player.name, player.lives)
		if count == 3:
			player.lives += 4
			$HUD.on_lives_changed(player.name, player.lives)
	if symbol == "🛡️":
		if count == 2:
			player.start_invincibility(3)
		if count == 3:
			player.start_invincibility(6)
	if symbol == "⚔️":
		if count == 2:
			player.damage += 1
		if count == 3:
			player.damage += 2

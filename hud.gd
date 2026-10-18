extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_lives_changed(player, lives):
	if player == "Player1":
		$"Player1Lives".text = "Player 1: " + str(lives)
	elif player == "Player2":
		$"Player2Lives".text = "Player 2: " + str(lives)


func display_current_time(time: float):
		$TimerLabel.text = ("%.1f" % time if time > 0 else "OVERTIME")

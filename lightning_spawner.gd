extends Node

@export var max_x: float
@export var min_x: float

signal player_hit(player, from_x)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_interval_timer_timeout() -> void:
	# Place the exclamation mark at any random point on the platform
	var x_position = randf_range(min_x, max_x)
	$WarningLabel.position = Vector2(x_position, 500)
	$StrikeArea.position = Vector2(x_position - 100, 0)
	$WarningTimer.start()
	$WarningLabel.text = "!"



func _on_warning_timer_timeout() -> void:
	$WarningLabel.text = ""
	$StrikeArea.visible = true
	check_hit()
	$LightningDurationTimer.start()
	
	# Reset lightning interval and make the duration shorter
	$IntervalTimer.wait_time *= 0.8
	$IntervalTimer.start()


func start_interval_timer():
	$IntervalTimer.start()


func check_hit():
	for body in $StrikeArea.get_overlapping_bodies():
		if body is CharacterBody2D:
			player_hit.emit(body, -1)


func _on_lightning_duration_timer_timeout() -> void:
	$StrikeArea.visible = false
	$LightningDurationTimer.wait_time *= 0.8

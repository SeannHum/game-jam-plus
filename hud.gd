extends CanvasLayer


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func on_lives_changed(player, lives):
	var hearts_array = get_node(player + "Lives").get_children()
	for life in range(len(hearts_array)):
		if life < lives:
			hearts_array[life].visible = true
		else:
			hearts_array[life].visible = false


func display_current_time(time: float):
		$TimerLabel.text = ("%.1f" % time if time > 0 else "OVERTIME")

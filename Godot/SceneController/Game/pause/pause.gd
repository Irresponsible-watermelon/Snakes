extends SubViewportContainer

var count = 0
func _process(delta: float) -> void:
	count += 1
	if count == 60:
		print_debug("Pause is processing")
		count = 0

extends Node2D

const X_LIMIT = 79

# if 60 fps move at 2px per frame
# 2 px/s
const SPEED = 0.6
var GameController

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	position.x += SPEED * 60 * delta
	
	if (position.x >= X_LIMIT):
		_delete_cloud()


func _delete_cloud() -> void:
	queue_free()

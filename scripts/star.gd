extends Node2D

const Y_LIMIT = -160

# if 60 fps move at 2px per frame
# 2 px/s
const SPEED = 0.2
@onready var sprite2d = $Sprite2D
var GameController

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameController.currentLevel == 0):
		_delete_star()
		return
		
	if (GameController.currentLevel <= 5):
		sprite2d.modulate.a = 0.4
	elif (GameController.currentLevel == 5):
		sprite2d.modulate.a = 0.6
	elif (GameController.currentLevel == 6):
		sprite2d.modulate.a = 0.8
	else:
		sprite2d.modulate.a = 1
		
	position.y -= SPEED * 60 * delta
	
	if (position.y <= Y_LIMIT):
		_delete_star()


func _delete_star() -> void:
	queue_free()

extends Node2D
class_name Balloon

const Y_LIMIT = -160

# if 60 fps move at 2px per frame
# 2 px/s
var speed = 0
var score = 0
var randomizeExplodingTimer = 0
var explosionLevel = 0
var shouldSelfPop = false
var popAfterMs = null
var avoidExtraEffects = false
@onready var animatedSprite2d = $AnimatedSprite2D
@onready var explodeStreamAudio = $ExplodeStreamAudio
var GameController

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if (GameController.gameOver):
		if (randomizeExplodingTimer == 0):
			randomizeExplodingTimer = GameController.rng.randf_range(0.001, 0.500)
		else:
			randomizeExplodingTimer -= delta
			
			if (randomizeExplodingTimer <= 0):
				_play_pop_animation()

	if (shouldSelfPop):
		popAfterMs -= delta * 1000
		
		if (popAfterMs <= 0):
			_on_pop()
	elif (GameController.explodeGreenBalloon):
		shouldSelfPop = true
		var distance = position.distance_to(GameController.locationGreenBalloon)
		avoidExtraEffects = true
		shouldSelfPop = true
		explosionLevel = 1
		popAfterMs = distance * 0.5

	position.y -= GameController.LEVELS[GameController.currentLevel].baseSpeed * speed * 60 * delta
	
	if (position.y <= Y_LIMIT && !GameController.gameOver && !shouldSelfPop):
		GameController.lives -= 1
		GameController.playHitSound()
		_delete_balloon()

func _on_pop() -> void:
	if (animatedSprite2d.animation == 'pop'):
		return
	
	_play_pop_animation()
	
	GameController.addScore(score - 50 * explosionLevel)

func _delete_balloon() -> void:
	queue_free()

func _play_sound() -> void:
	explodeStreamAudio.play()
	
func _play_pop_animation() -> void:
	if (animatedSprite2d.animation != 'pop'):
		_play_sound()
		animatedSprite2d.animation = 'pop'
		animatedSprite2d.connect("animation_finished", _delete_balloon, 0)

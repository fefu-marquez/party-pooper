extends Balloon

const FAST_SPEED = 1.35
const EXPLOSION_SPEED = 5

@onready var firstHitStreamAudio = $FirstHitAudio
var lives = 1


func _ready() -> void:
	speed = 0.75
	score = 2500

func _on_pop():
	if (lives > 0):
		firstHitStreamAudio.play()
		speed = FAST_SPEED
		lives -= 1
	else: 
		super._on_pop()
		
		GameController.locationGreenBalloon = position
		GameController.explodeGreenBalloon = true
		GameController.tickStopExploding = Time.get_ticks_msec() + 17 # 17ms is about a frame at 60 fps

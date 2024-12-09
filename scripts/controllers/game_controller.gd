extends Node2D

const MINIMUM_TIME_FOR_SPAWNING_BALLONS_IN_SECONDS = 0.2
const BALLOON_SPAWN_Y = 162
const CHANCE_SPAWN_YELLOW_BALLOON = 0.1
const CHANCE_SPAWN_GREEN_BALLOON = 0.15
const BUFFER_NEW_GAME_TIME_IN_SECONDS = 2

const LEVELS = [
	{
		"baseSpeed": 0.5,
		"baseDelay": 2.4,
		"extraSpawns": 0,
		"nextLevel": 600,
		"yellowSpawnBonus": 1,
		"bgColor": "#329aff",
	},
	{
		"baseSpeed": 0.7,
		"baseDelay": 2.0,
		"extraSpawns": 0,
		"nextLevel": 1500,
		"yellowSpawnBonus": 1,
		"bgColor": "#327aff",
	},
	{
		"baseSpeed": 0.9,
		"baseDelay": 1.6,
		"extraSpawns": 0,
		"nextLevel": 4000,
		"yellowSpawnBonus": 1,
		"bgColor": "#323aff",
	},
	{
		"baseSpeed": 1.1,
		"baseDelay": 1.2,
		"extraSpawns": 0,
		"nextLevel": 8000,
		"yellowSpawnBonus": 1,
		"bgColor": "#3200ff",
	},
	{
		"baseSpeed": 1.1,
		"baseDelay": 0.6,
		"extraSpawns": 0,
		"nextLevel": 10000,
		"yellowSpawnBonus": 1,
		"bgColor": "#1800dd",
	},
	{
		"baseSpeed": 1.1,
		"baseDelay": 0.2,
		"extraSpawns": 0,
		"nextLevel": 20000,
		"yellowSpawnBonus": 1.8,
		"bgColor": "#1800bb",
	},
	{
		"baseSpeed": 1.1,
		"baseDelay": 0.2,
		"extraSpawns": 1,
		"nextLevel": 35000,
		"yellowSpawnBonus": 2.25,
		"bgColor": "#0f0f0f",
	},
	{
		"baseSpeed": 1.3,
		"baseDelay": 0.2,
		"extraSpawns": 1,
		"nextLevel": 50000,
		"yellowSpawnBonus": 2.6,
		"bgColor": "#0f0f0f",
	},
	{
		"baseSpeed": 1.3,
		"baseDelay": 0.2,
		"extraSpawns": 2,
		"nextLevel": 100000,
		"yellowSpawnBonus": 3,
		"bgColor": "#0f0f0f",
	},
]

var red_balloon = preload("res://scenes/game_objects/red_balloon.tscn")
var yellow_balloon = preload("res://scenes/game_objects/yellow_balloon.tscn")
var green_balloon = preload("res://scenes/game_objects/green_balloon.tscn")
var hit_sound = preload("res://assets/sfx/hit.wav")
var hit_sound_player = AudioStreamPlayer2D.new()

var buffer_new_game = 0
var time_since_last_spawn = 0
var rng = RandomNumberGenerator.new()
var totalScore = 0
var lives = 3
var gameOver = false
var currentLevel = 0
var explodeGreenBalloon = false
var tickStopExploding = -1
var locationGreenBalloon

func _ready() -> void:
	_instance_sound_player()
	
func _process(delta: float) -> void:	
	if (explodeGreenBalloon && Time.get_ticks_msec() >= tickStopExploding):
		explodeGreenBalloon = false
		locationGreenBalloon = null
		tickStopExploding = -1
		
	if (lives <= 0):
		if (!gameOver):
			get_node("/root/Main/ScoreBar").set_visible(false)
			gameOver = true
			buffer_new_game = BUFFER_NEW_GAME_TIME_IN_SECONDS
			get_node("/root/Main/GameOverScreen").set_visible(true)	
		else:
			if (buffer_new_game > 0):
				buffer_new_game -= delta
		return
	
	if (time_since_last_spawn <= 0):
		for i in range(1+LEVELS[currentLevel].extraSpawns):
			var rareBalloon = rng.randf()
			
			if (rareBalloon <= CHANCE_SPAWN_YELLOW_BALLOON * LEVELS[currentLevel].yellowSpawnBonus):
				if (currentLevel >= 5):
					var ultraRareBalloon = rng.randf()
					 
					if (ultraRareBalloon <= CHANCE_SPAWN_GREEN_BALLOON):
						_instance_green_balloon()
					else:
						_instance_yellow_balloon()
				else:
					_instance_yellow_balloon()
			else:
				_instance_red_balloon()
		time_since_last_spawn = MINIMUM_TIME_FOR_SPAWNING_BALLONS_IN_SECONDS + LEVELS[currentLevel].baseDelay
	else:
		time_since_last_spawn -= delta

func _instance_sound_player():
	hit_sound_player.stream = hit_sound
	add_child(hit_sound_player)

func _instance_green_balloon():
	_instance_balloon(green_balloon)

func _instance_yellow_balloon():
	_instance_balloon(yellow_balloon)
	
func _instance_red_balloon():
	_instance_balloon(red_balloon)
	
func _instance_balloon(balloon_scene: PackedScene) -> void:
	var random_x = rng.randi_range(-56, 56)
		
	var new_balloon = balloon_scene.instantiate()
	
	new_balloon.position.x = random_x
	new_balloon.position.y = BALLOON_SPAWN_Y + rng.randi_range(-15, 15)
	
	new_balloon.GameController = self
	
	add_child(new_balloon)

func addScore(score: int) -> void:
	totalScore += score
	
	if (totalScore >= LEVELS[currentLevel].nextLevel && currentLevel < len(LEVELS) - 1):
		currentLevel += 1
		RenderingServer.set_default_clear_color(Color(LEVELS[currentLevel].bgColor))
		
func playHitSound() -> void:
	(hit_sound_player as AudioStreamPlayer2D).play()

func startNewGame() -> void:
	if (buffer_new_game > 0):
		return
		
	get_node("/root/Main/GameOverScreen").set_visible(false)
	get_node("/root/Main/ScoreBar").set_visible(true)
	currentLevel = 0
	RenderingServer.set_default_clear_color(Color(LEVELS[currentLevel].bgColor))
	totalScore = 0
	lives = 3
	gameOver = false
	

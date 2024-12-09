extends Node2D

var minimumTimeForSpawningStarsInSeconds = 10
const STAR_SPAWN_Y = 162

var timeSinceLastSpawn = 0
var star = preload("res://scenes/game_objects/star.tscn")

@onready var GameController = $".."

func _process(delta: float) -> void:	
	if (GameController.currentLevel <= 3):
		minimumTimeForSpawningStarsInSeconds = 10
	elif (GameController.currentLevel == 4):
		minimumTimeForSpawningStarsInSeconds = 5
	elif (GameController.currentLevel == 5):
		minimumTimeForSpawningStarsInSeconds = 0.8
	else:
		minimumTimeForSpawningStarsInSeconds = 0.1
		
	if (GameController.currentLevel >= 3):
		if (timeSinceLastSpawn <= 0):
			_instance_star()
			timeSinceLastSpawn = minimumTimeForSpawningStarsInSeconds + GameController.rng.randf_range(-0.1, 0.1)
		else:
			timeSinceLastSpawn -= delta

func _instance_star() -> void:
	var random_x = GameController.rng.randi_range(-64, 64)
		
	var new_star = star.instantiate()
	
	new_star.position.x = random_x
	new_star.position.y = STAR_SPAWN_Y + GameController.rng.randi_range(-15, 15)
	
	new_star.GameController = GameController
	
	add_child(new_star)

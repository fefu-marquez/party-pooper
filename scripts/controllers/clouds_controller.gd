extends Node2D

const MINIMUM_TIME_FOR_SPAWNING_CLOUDS_IN_SECONDS = 2
const CLOUD_SPAWN_X = -93

var timeSinceLastSpawn = 0
var cloud = preload("res://scenes/game_objects/cloud.tscn")
@onready var GameController = $".."

func _process(delta: float) -> void:
	if (GameController.currentLevel < 6):
		if (timeSinceLastSpawn <= 0):
			_instance_cloud()
			timeSinceLastSpawn = MINIMUM_TIME_FOR_SPAWNING_CLOUDS_IN_SECONDS + GameController.rng.randf_range(-0.1, 0.1)
		else:
			timeSinceLastSpawn -= delta

func _instance_cloud() -> void:
	var random_y = GameController.rng.randi_range(0, 78)
		
	var new_cloud = cloud.instantiate()
	new_cloud.GameController = GameController
	
	new_cloud.position.x = CLOUD_SPAWN_X + GameController.rng.randi_range(-15, 15)
	new_cloud.position.y = random_y
	
	add_child(new_cloud)

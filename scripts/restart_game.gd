extends TouchScreenButton

@onready var GameController = $"../.."

func on_pressed() -> void:
	GameController.startNewGame()

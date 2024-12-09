extends RichTextLabel

@onready var GameController = $"../.."

func _process(_delta: float) -> void:
	if (GameController.gameOver):
		self.text = "[center]Final score: " + str(GameController.totalScore) + "[/center]"
	else:
		self.text = "Score: " + str(GameController.totalScore)

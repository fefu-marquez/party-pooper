extends RichTextLabel

@onready var GameController = $"../.."

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	self.text = "Lives: " + str(GameController.lives)

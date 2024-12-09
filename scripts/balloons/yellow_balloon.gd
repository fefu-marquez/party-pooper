extends Balloon

const EXPLOSION_SPEED = 3

@onready var areaOfExplosion = $ExplodingArea

func _ready() -> void:
	speed = 1.125
	score = 500

func _on_pop() -> void:	
	super._on_pop()
	
	if !avoidExtraEffects:
		for area in areaOfExplosion.get_overlapping_areas():
			if (area.name == "ExplodingArea" || area.get_parent() == self):
				continue
			
			var distance = position.distance_to(area.get_parent().position)
			var balloon = (area.get_parent() as Balloon)
			
			if (!balloon.shouldSelfPop && (balloon.score != score || (balloon.score == score && explosionLevel < 2))):
				balloon.shouldSelfPop = true
				balloon.explosionLevel = explosionLevel + 1
				balloon.popAfterMs = distance * EXPLOSION_SPEED

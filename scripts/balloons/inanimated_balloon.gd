extends Node2D

@onready var animatedSprite2d = $AnimatedSprite2D
@onready var explodeStreamAudio = $ExplodeStreamAudio

func _on_pop() -> void:
	if (animatedSprite2d.animation == 'pop'):
		return
	
	_play_pop_animation()

func _play_sound() -> void:
	explodeStreamAudio.play()
	
func _play_pop_animation() -> void:
	if (animatedSprite2d.animation != 'pop'):
		_play_sound()
		animatedSprite2d.animation = 'pop'
		animatedSprite2d.connect("animation_finished", _change_scene, 0)
		
func _change_scene() -> void: 
	get_tree().change_scene_to_file("res://scenes/main.tscn")

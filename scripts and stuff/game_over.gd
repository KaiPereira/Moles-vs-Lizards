extends Sprite2D

func _ready() -> void:
	await get_tree().create_timer(4.0).timeout
	
	GameManager.reset_game()
	
	get_tree().change_scene_to_file("res://scenes, scenes and scenes/floor1.tscn")

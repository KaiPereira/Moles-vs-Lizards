extends Sprite2D

@export var next_scene: PackedScene
@export var player: CharacterBody2D

var level_beat = false
@onready var icon = $EIcon
var active = false

var original_y : float
var float_amplitude : float = 10.0
var float_speed : float = 2.0

func _ready() -> void:
	original_y = icon.position.y
	visible = false;

func _process(delta: float) -> void:
	icon.position.y = original_y + (sin(Time.get_ticks_msec() / 1000.0 * float_speed * PI) * float_amplitude)
	check_all_enemies_gone();
	
	if (level_beat && Input.is_action_pressed("interact")):
		get_tree().change_scene_to_file(next_scene.resource_path);
		player.reset_health_signals()

func check_all_enemies_gone():
	var enemies_left = get_tree().get_nodes_in_group("enemies").size()
	
	if enemies_left == 0:
		active = true;
		visible = true;
		level_beat = true;

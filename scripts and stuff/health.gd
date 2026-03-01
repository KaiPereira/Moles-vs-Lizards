extends CanvasLayer

@onready var health_container = $HUD/HealthBar
@onready var shield_container = $HUD/ShieldBar

@export var player: CharacterBody2D 

@export var heart_full: Texture2D
@export var heart_empty: Texture2D
@export var shield_full: Texture2D
@export var shield_empty: Texture2D

var shield_regen_rate = 10;

func _ready():
	if player:
		player.health_changed.connect(_on_health_changed)
		player.shield_changed.connect(_on_shield_changed)
		# Initialize display
		_on_health_changed(player.current_health, player.max_health)
		_on_shield_changed(player.current_shield, player.max_shield)
	
	while (true):
		await get_tree().create_timer(shield_regen_rate).timeout
	
		player.gain_shield();

func _on_health_changed(current, max_val):
	_update_icon_container(health_container, current, heart_full, heart_empty)

func _on_shield_changed(current, max_val):
	_update_icon_container(shield_container, current, shield_full, shield_empty)

func _update_icon_container(container: Node, current_amount: int, full_tex: Texture2D, empty_tex: Texture2D):
	var icons = container.get_children()
	for i in range(icons.size()):
		if i < current_amount:
			icons[i].texture = full_tex
			icons[i].visible = true
		else:
			icons[i].visible = false

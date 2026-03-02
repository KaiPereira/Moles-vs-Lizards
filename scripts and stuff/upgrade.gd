extends Button

enum Upgrade { BULLET, DAMAGE, HEALTH, REGEN, SHIELD, ICE, FIRE, SAW }

@export var selected_upgrade: Upgrade
@export var player: CharacterBody2D
@export var menu_root: Control
@export var hole: Sprite2D

func apply_upgrade():
	match selected_upgrade:
		Upgrade.HEALTH: 
			player.gain_max_health(2);
		Upgrade.DAMAGE:
			GameManager.damage += 10;
		Upgrade.REGEN:
			player.regen();
		Upgrade.SHIELD:
			player.gain_max_shield(2);
		Upgrade.BULLET:
			GameManager.bullets += 1;
		# Upgrade.ICE:
		# Upgrade.FIRE:
		# Upgrade.SAW:

func _on_pressed() -> void:
	apply_upgrade()
	menu_root.visible = false;
	hole.active = false;

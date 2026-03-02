extends Node

var max_health = 4
var current_health = 4

var max_shield = 3
var current_shield = 3

var damage = 500;
var bullets = 1;

var saw = false;

signal health_changed(current_health, max_health)
signal shield_changed(current_shield, max_shield)

func reset_game():
	max_health = 4
	current_health = 4

	max_shield = 3
	current_shield = 3

	damage = 10;
	bullets = 1;

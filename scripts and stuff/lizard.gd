extends CharacterBody2D

# Some random config stuff ykyk
@export var speed = 400
@export var wobble_speed = 12.0;
@export var wobble_radians = 0.2

@export var bullet_scene: PackedScene

@onready var sprite = $AnimatedSprite2D

# WOBBLE WOBBLE WALK :D 
var wobble_time := 0.0
var is_moving := false

# Health shenanigans
var max_health = 4
var current_health = 4

var max_shield = 3
var current_shield = 3

signal health_changed(current_health, max_health)
signal shield_changed(current_shield, max_shield)

func _ready():
	emit_signal("health_changed", current_health, max_health)
	emit_signal("shield_changed", current_shield, max_shield)

func kaboom(amount):
	if current_shield > 0:
		if current_shield >= amount:
			current_shield -= amount
			amount = 0
		else:
			amount -= current_shield
			current_shield = 0
		emit_signal("shield_changed", current_shield, max_shield)
	
	if amount > 0:
		current_health -= amount
		current_health = clamp(current_health, 0, max_health)
		emit_signal("health_changed", current_health, max_health)
	
	if current_health <= 0:
		die()

func die():
	print("Player Died")

# PEW PEW 
func shoot():
	var bullet = bullet_scene.instantiate()
	get_tree().current_scene.add_child(bullet)
	
	bullet.global_position = $Muzzle.global_position

	var mouse_pos = get_global_mouse_position()
	var dir = (mouse_pos - global_position).normalized()

	bullet.direction = dir	


func _input(event: InputEvent) -> void:
	if event.is_action_pressed("click"):
		sprite.play("throw")
		shoot()


func _process(delta):
	var mouse_pos = get_global_mouse_position()
	
	if mouse_pos.x > global_position.x:
		sprite.flip_h = true
	else:
		sprite.flip_h = false


func get_input():
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	is_moving = input_direction.length() > 0


func _physics_process(delta):
	get_input()
	move_and_slide()
	
	apply_wobble(delta)


func apply_wobble(delta):
	if is_moving:
		wobble_time += delta * wobble_speed
		sprite.rotation = sin(wobble_time) * wobble_radians
	else:
		sprite.rotation = lerp(sprite.rotation, 0.0, 10 * delta)


func _on_h_box_container_2_property_list_changed() -> void:
	pass # Replace with function body.

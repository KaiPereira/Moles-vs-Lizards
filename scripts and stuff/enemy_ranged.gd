extends CharacterBody2D

@export var health: int = 100
@onready var player_node = get_node("../Player")
@onready var animated_sprite = $AnimatedSprite2D
@export var drill_scene: PackedScene

@export var speed = 100
@export var preferred_distance = 100.0
@export var distance_tolerance = 10.0

@export var wobble_speed = 4.0
@export var wobble_radians = 0.01
var wobble_time := 0.0

var can_attack = true
var is_attacking = false
@export var attack_cooldown: float = 4.0

func _physics_process(delta: float) -> void:
	if not player_node:
		return
		
	apply_wobble(delta)
	
	var direction_to_player = global_position.direction_to(player_node.global_position)
	var distance_to_player = global_position.distance_to(player_node.global_position)
	
	if distance_to_player < (preferred_distance - distance_tolerance):
		velocity = -direction_to_player * speed
	elif distance_to_player > (preferred_distance + distance_tolerance):
		velocity = direction_to_player * speed
	else:
		start_attack()
		
	move_and_slide()

func take_damage(amount: int):
	health -= amount
	print("Enemy hit! Health remaining: ", health)
	
	if health <= 0:
		die()

func die():
	queue_free()
	
func apply_wobble(delta):
	wobble_time += delta * wobble_speed
	rotation = sin(wobble_time) * wobble_radians

func start_attack():
	if not can_attack:
		return
		
	is_attacking = true
	can_attack = false
	
	animated_sprite.play("shoot")
	
	await animated_sprite.animation_finished
	
	shoot()
	
	await get_tree().create_timer(attack_cooldown).timeout
	
	animated_sprite.play("default")
	
	can_attack = true
	is_attacking = false


func shoot():
	var drill = drill_scene.instantiate()
	get_tree().current_scene.add_child(drill)
	
	drill.global_position = global_position

	var dir = global_position.direction_to(player_node.global_position)

	drill.direction = dir
	drill.rotation = dir.angle() + PI

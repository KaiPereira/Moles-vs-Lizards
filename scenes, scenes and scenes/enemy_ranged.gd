extends CharacterBody2D

@export var health: int = 100
@export var speed: float = 150.0
@export var desired_distance: float = 300.0 # How far to stay away

@onready var player_node = get_node("../Player")

# Wobble settings
@export var wobble_speed = 4.0
@export var wobble_radians = 0.01
var wobble_time := 0.0

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
	
func _process(delta: float) -> void:
	apply_wobble(delta)

func _physics_process(delta: float) -> void:
	if not player_node:
		return
		
	# Calculate horizontal distance to player
	var dir_to_player = player_node.global_position.x - global_position.x
	
	# Determine horizontal movement based on distance
	if abs(dir_to_player) < desired_distance:
		# Too close: Move away horizontally
		velocity.x = -sign(dir_to_player) * speed
	elif abs(dir_to_player) > desired_distance + 20: # +20 to prevent jitter
		# Too far: Move closer horizontally
		velocity.x = sign(dir_to_player) * speed
	else:
		# Within range: Stop horizontal movement
		velocity.x = 0
		
	move_and_slide()

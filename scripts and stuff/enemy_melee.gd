extends CharacterBody2D

@export var wobble_speed = 8.0
@export var wobble_radians = 0.1
var wobble_time := 0.0

@export var speed = 80
var direction = Vector2.ZERO

@export var player_path: NodePath
var player: Node2D
@onready var animated_sprite = $AnimatedSprite2D

@export var attack_cooldown = 1.0
@export var attack_range = 150.0
@export var hit_distance = 150.0
var can_attack = true
var is_attacking = false


@export var health: int = 100

@onready var player_node = get_node("../Player")

func take_damage(amount: int):
	health -= amount
	
	var tween = create_tween()
	
	modulate = Color.ROSY_BROWN
	
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)
	
	if health <= 0:
		die()

func die():
	queue_free()
	
	
func _ready():
	if player_path != null:
		player = get_node(player_path)

func apply_wobble(delta):
	wobble_time += delta * wobble_speed
	rotation = sin(wobble_time) * wobble_radians

func _process(delta: float) -> void:
	if player != null:
		var target_vector = player.global_position - global_position
		var distance_to_player = target_vector.length()
		
		if target_vector.x < 0:
			animated_sprite.flip_h = false
		else:
			animated_sprite.flip_h = true
			
		if distance_to_player > 100.0:
			direction = target_vector.normalized()
			
			var move_step = speed * delta
			
			if move_step > distance_to_player:
				global_position = player.global_position
			else:
				global_position += direction * move_step
		else:
			if not is_attacking:
				start_attack()
	
	apply_wobble(delta)



func start_attack():
	if not can_attack:
		return
		
	is_attacking = true
	can_attack = false
	
	animated_sprite.play("hit")
	
	await animated_sprite.animation_finished
	
	check_hit()
	
	await get_tree().create_timer(attack_cooldown).timeout
	can_attack = true
	is_attacking = false

func check_hit():
	if player == null: return
	
	var distance_to_player = global_position.distance_to(player.global_position)
		
	if distance_to_player <= hit_distance:
		player_node.kaboom(1);
		print("Hit!")
	else:
		print("Missed!")

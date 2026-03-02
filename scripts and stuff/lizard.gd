extends CharacterBody2D

# Some random config stuff ykyk
@export var speed = 400
@export var wobble_speed = 12.0;
@export var wobble_radians = 0.2

@export var bullet_scene: PackedScene

@onready var sprite = $AnimatedSprite2D
@export var game_over_screen: Sprite2D

# WOBBLE WOBBLE WALK :D 
var wobble_time := 0.0
var is_moving := false

func reset_health_signals():
	GameManager.health_changed.emit(GameManager.current_health, GameManager.max_health)
	GameManager.shield_changed.emit(GameManager.current_shield, GameManager.max_shield)

func _ready():
	GameManager.health_changed.emit(GameManager.current_health, GameManager.max_health)
	GameManager.shield_changed.emit(GameManager.current_shield, GameManager.max_shield)
	
func regen():
	GameManager.current_health = GameManager.max_health;
	
	GameManager.health_changed.emit(GameManager.current_health, GameManager.max_health)

func upgrade_damage(amount: int):
	GameManager.damage += amount

func gain_max_shield(amount):
	GameManager.max_shield += amount;
	GameManager.current_shield += amount;
		
	GameManager.shield_changed.emit(GameManager.current_shield, GameManager.max_shield)

func gain_max_health(amount):
	GameManager.max_health += amount;
	GameManager.current_health += amount;
		
	GameManager.health_changed.emit(GameManager.current_health, GameManager.max_health)
	
func gain_shield():
	if (GameManager.current_shield < GameManager.max_shield):
		GameManager.current_shield += 1;
	GameManager.shield_changed.emit(GameManager.current_shield, GameManager.max_shield)

func kaboom(amount):
	if GameManager.current_shield > 0:
		if GameManager.current_shield >= amount:
			GameManager.current_shield -= amount
			amount = 0
		else:
			amount -= GameManager.current_shield
			GameManager.current_shield = 0
		GameManager.shield_changed.emit(GameManager.current_shield, GameManager.max_shield)
	
	if amount > 0:
		GameManager.current_health -= amount
		GameManager.current_health = clamp(GameManager.current_health, 0, GameManager.max_health)
		GameManager.health_changed.emit(GameManager.current_health, GameManager.max_health)
	
	if GameManager.current_health <= 0:
		die()
	
	var tween = create_tween()
	
	modulate = Color.RED
	
	tween.tween_property(self, "modulate", Color.WHITE, 0.2)

func die():
	game_over_screen.visible = true;
	await get_tree().create_timer(4.0).timeout
	
	GameManager.reset_game()
	reset_health_signals()
	get_tree().reload_current_scene()

# PEW PEW 
func shoot():
	for i in GameManager.bullets:
		var bullet = bullet_scene.instantiate()

		get_tree().current_scene.add_child(bullet)
	
		bullet.damage = GameManager.damage;
		bullet.global_position = Vector2($Muzzle.global_position.x + (i - 1 * 10), $Muzzle.global_position.y);

		var mouse_pos = get_global_mouse_position()
		var dir = (mouse_pos - global_position).normalized()
		
		var spread_amount = 0.5
		
		bullet.direction = dir.rotated((i - (GameManager.bullets - 1) / 2.0) * spread_amount)

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

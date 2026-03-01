extends Area2D

@export var damage: int = 10
@export var speed = 800
var direction = Vector2.ZERO

func _ready():
	rotation = direction.angle()
	
	await get_tree().create_timer(5.0).timeout
	queue_free()

func _process(delta: float):
	position += direction * speed * delta

func _on_body_entered(body):
	if body.has_method("kaboom"):
		body.kaboom(damage)
		
		queue_free()

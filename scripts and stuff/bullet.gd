extends Area2D

@export var damage: int = 10
@export var speed = 800
var direction = Vector2.ZERO

func _process(delta: float):
	position += direction * speed * delta
	rotation += 0.2

func _on_body_entered(body):
	if body.has_method("take_damage"):
		body.take_damage(damage)
		await get_tree().create_timer(0.08).timeout
		queue_free()

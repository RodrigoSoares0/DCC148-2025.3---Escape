extends Area3D

var speed = 50.0
var direction = Vector3.FORWARD

func _physics_process(delta):
	global_translate(direction * speed * delta)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("take_damage"):
			body.take_damage(2)
		queue_free()
	
	elif not body.is_in_group("Enemy"):
		queue_free()

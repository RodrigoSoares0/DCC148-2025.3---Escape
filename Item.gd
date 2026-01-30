extends Area3D

func _ready():
	if not body_entered.is_connected(_on_body_entered):
		body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.has_method("add_item"):
			body.add_item()
			$AudioStreamPlayer3D.play()
			visible = false
			set_deferred("monitoring", false) 
			await $AudioStreamPlayer3D.finished 
			queue_free()

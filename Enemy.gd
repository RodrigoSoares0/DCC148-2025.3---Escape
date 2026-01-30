extends CharacterBody3D

@export var target: CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var timer = get_node_or_null("WaitTimer")
@onready var animation_player: AnimationPlayer = $Sketchfab_Scene1/AnimationPlayer

var can_chase = true
var speed = 1.2

func _ready():
	if timer:
		timer.one_shot = true
		timer.wait_time = 5.0
		timer.timeout.connect(_on_wait_timer_timeout)
	
	nav_agent.path_desired_distance = 0.5
	nav_agent.target_desired_distance = 0.5
			
func _physics_process(_delta):
	if not target or not can_chase:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	nav_agent.target_position = target.global_position

	var next_pos = nav_agent.get_next_path_position()
	var diff = next_pos - global_position
	var dist_ao_alvo = global_position.distance_to(target.global_position)
	
	var look_pos = Vector3(target.global_position.x, global_position.y, target.global_position.z)
	if dist_ao_alvo > 0.1:
		look_at(look_pos, Vector3.UP)

	var dir: Vector3
	if dist_ao_alvo < 1.5:
		dir = (target.global_position - global_position).normalized()
	else:
		dir = diff.normalized()
	
	dir.y = 0 
	
	velocity = dir * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		
		if collider.is_in_group("Player") and can_chase:
			atacar_player(collider)
			
	if animation_player:
		if velocity.length() > 0.1:
			if animation_player.current_animation != "mixamo_com":
				animation_player.play("mixamo_com")
		else:
			if animation_player.current_animation != "[stop]":
				animation_player.play("[stop]")

func _on_attack_area_body_entered(body):
	if body.is_in_group("Player") and can_chase:
		atacar_player(body)

func atacar_player(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
	
	can_chase = false
	if timer:
		timer.start()

func _on_wait_timer_timeout():
	can_chase = true

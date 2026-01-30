extends CharacterBody3D

@export var target: CharacterBody3D
@export var bullet_scene: PackedScene = preload("res://Bullet.tscn")

@onready var nav_agent = $NavigationAgent3D
@onready var wait_timer = get_node_or_null("WaitTimer")
@onready var shoot_timer = get_node_or_null("ShootTimer")
@onready var muzzle = get_node_or_null("Muzzle")
@onready var animation_player: AnimationPlayer = $Sketchfab_Scene/AnimationPlayer


var can_chase = true
var speed = 1.35

func _ready():
	if wait_timer:
		wait_timer.one_shot = true
		if not wait_timer.timeout.is_connected(_on_wait_timer_timeout):
			wait_timer.timeout.connect(_on_wait_timer_timeout)
	
	if shoot_timer:
		shoot_timer.one_shot = true
		if not shoot_timer.timeout.is_connected(_on_shoot_timer_timeout):
			shoot_timer.timeout.connect(_on_shoot_timer_timeout)
		call_deferred("_definir_proximo_tiro")
	else:
		push_error("ERRO: Nó ShootTimer não encontrado no EnemyShooter!")

func _physics_process(_delta):
	if not target or not can_chase:
		velocity = Vector3.ZERO
		move_and_slide()
		return

	nav_agent.target_position = target.global_position
	var dist_ao_alvo = global_position.distance_to(target.global_position)
	
	var look_pos = Vector3(target.global_position.x, global_position.y, target.global_position.z)
	if dist_ao_alvo > 0.1:
		look_at(look_pos, Vector3.UP)

	var next_pos = nav_agent.get_next_path_position()
	var dir = (next_pos - global_position).normalized()
	if dist_ao_alvo < 1.5:
		dir = (target.global_position - global_position).normalized()
	
	dir.y = 0
	velocity = dir * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Player") and can_chase:
			_atacar_contato(collider)
			
	if animation_player:
		if velocity.length() > 0.1:
			if animation_player.current_animation != "RIG-Finger_LPFinger_LiFinger_LnFinger_LkFinger_LyFinger_L_F_001|Action":
				animation_player.play("RIG-Finger_LPFinger_LiFinger_LnFinger_LkFinger_LyFinger_L_F_001|Action")
		else:
			if animation_player.current_animation != "[stop]":
				animation_player.play("[stop]")

func _definir_proximo_tiro():
	if shoot_timer:
		var tempo = randf_range(3.0, 10.0)
		shoot_timer.start(tempo)
		print("Próximo tiro em: ", tempo, " segundos.")

func _on_shoot_timer_timeout():
	if can_chase and target:
		atirar()
	_definir_proximo_tiro()

func atirar():
	$AudioStreamPlayer3D.play() 
	if bullet_scene and muzzle:
		var b = bullet_scene.instantiate()
		get_tree().root.add_child(b)
		b.global_transform = muzzle.global_transform

		b.direction = -global_transform.basis.z
		print("Inimigo atirou!")

func _atacar_contato(body):
	if body.has_method("take_damage"):
		body.take_damage(1)
	can_chase = false
	if wait_timer:
		wait_timer.start()

func _on_wait_timer_timeout():
	can_chase = true

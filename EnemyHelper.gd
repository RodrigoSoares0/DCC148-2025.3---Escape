extends CharacterBody3D

@export var target: CharacterBody3D
@onready var nav_agent = $NavigationAgent3D
@onready var timer = get_node_or_null("WaitTimer")
@onready var animation_player: AnimationPlayer = $Sketchfab_Scene/AnimationPlayer

var can_chase = true
var speed = 1.0

func _ready():
	if timer:
		timer.wait_time = 5.0
		timer.one_shot = true
		timer.timeout.connect(_on_wait_timer_timeout)
	nav_agent.target_desired_distance = 0.5

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
	dir.y = 0
	
	velocity = dir * speed
	move_and_slide()
	
	for i in get_slide_collision_count():
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("Player") and can_chase:
			dar_dica()
	if animation_player:
		if velocity.length() > 0.1:
			if animation_player.current_animation != "2762272363296_TempMotion":
				animation_player.play("2762272363296_TempMotion")
		else:
			if animation_player.current_animation != "[stop]":
				animation_player.play("[stop]")


func dar_dica():
	var hud = get_tree().get_first_node_in_group("HUD")
	var itens_restantes = get_tree().get_nodes_in_group("Item")
	var texto_dica = ""
	
	if itens_restantes.size() > 0:
		var item_foco = itens_restantes[0]
		var nome_item = item_foco.name
		
		match nome_item:
			"Item1":
				texto_dica = "DICA: O item esta proximo das pilastras vermelhas!"
			"Item2":
				texto_dica = "DICA: O item esta escondido em um dos quartos!"
			"Item3":
				texto_dica = "DICA: Procure o item perto do cubo flutuante!"
			"Item4":
				texto_dica = "DICA: O item esta proximo da borda!"
			"Item5":
				texto_dica = "DICA: O item esta proximo das paredes azuis!"

	else:
		texto_dica = "DICA: Todos os itens coletados! Não posso mais ajudar, fuja rápido!"

	if hud and hud.has_method("display_message"):
		hud.display_message(texto_dica)
	else:
		print(texto_dica)

	can_chase = false
	if timer:
		timer.start()
		
func _on_wait_timer_timeout():
	can_chase = true

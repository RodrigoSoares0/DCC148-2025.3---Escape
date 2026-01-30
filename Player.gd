extends CharacterBody3D

signal health_changed(new_health)
signal items_changed(count)

var health = 10
var items_collected = 0
var speed = 1.5

@export var mouse_sensitivity: float = 0.001
@onready var pivot = $CameraPivot
@onready var camera = $CameraPivot/Camera3D

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	add_to_group("Player")

func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x * mouse_sensitivity)
		pivot.rotate_x(event.relative.y * mouse_sensitivity)
		pivot.rotation.x = clamp(pivot.rotation.x, deg_to_rad(-80), deg_to_rad(80))

func _physics_process(_delta):
	var input_dir = Input.get_vector("ui_left", "ui_right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(-input_dir.x, 0, -input_dir.y)).normalized()
	
	if direction:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
		velocity.z = move_toward(velocity.z, 0, speed)

	move_and_slide()

func take_damage(amount):
	print("FUNÇÃO TAKE_DAMAGE CHAMADA! Vida anterior: ", health)
	if has_node("HurtSound"): $HurtSound.play() 
	health -= amount
	health_changed.emit(health)
	if health <= 0:
		get_tree().change_scene_to_file("res://GameOver.tscn")

func add_item():
	items_collected += 1
	items_changed.emit(items_collected)

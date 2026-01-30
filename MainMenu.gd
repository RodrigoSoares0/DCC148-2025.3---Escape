extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	$StartButton.pressed.connect(_on_start_pressed)
	$Quit.pressed.connect(_on_quit_pressed)
	$Credits.pressed.connect(_on_credits_pressed)

func _on_start_pressed():
	get_tree().change_scene_to_file("res://Fase_1.tscn")

func _on_quit_pressed():
	get_tree().quit()

func _on_credits_pressed():
	get_tree().change_scene_to_file("res://Credits.tscn")

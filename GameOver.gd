extends Control

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE) 
	$Restart.pressed.connect(_on_restart_pressed)
	$StartingScreen.pressed.connect(_on_starting_screen_pressed)
	$Quit.pressed.connect(_on_quit_pressed)

func _on_restart_pressed():
	get_tree().change_scene_to_file("res://Fase_1.tscn")
	
func _on_starting_screen_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")

func _on_quit_pressed():
	get_tree().quit()
	

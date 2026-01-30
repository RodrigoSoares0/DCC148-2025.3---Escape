extends Control


func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	$Voltar.pressed.connect(_on_voltar_pressed)

func _on_voltar_pressed():
	get_tree().change_scene_to_file("res://MainMenu.tscn")
	

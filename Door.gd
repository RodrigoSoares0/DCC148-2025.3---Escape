extends Area3D

@export_file("*.tscn") var proxima_fase_path

func _ready():
	body_entered.connect(_on_body_entered)

func _on_body_entered(body):
	if body.is_in_group("Player"):
		if body.items_collected >= 5:
			if proxima_fase_path != "":
				get_tree().change_scene_to_file(proxima_fase_path)
			else:
				print("Concluiu todas as fases")
				get_tree().change_scene_to_file("res://MainMenu.tscn")
		else:
			print("porta está trancada")

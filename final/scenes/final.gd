extends Control

func _on_restart_pressed() -> void:
	# Vuelve al nivel 9 cuando se presiona el botón
	get_tree().change_scene_to_file("res://scenes/level9.tscn")

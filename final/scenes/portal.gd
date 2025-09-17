extends Area2D

func _ready() -> void:
	if has_node("AnimatedSprite2D"):
		$AnimatedSprite2D.play()

func _on_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if has_node("sound"):
			$sound.play()
			await $sound.finished
		get_tree().change_scene_to_file("res://scenes/mantis_boss_arena.tscn")

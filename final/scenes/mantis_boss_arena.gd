extends Node2D

var mantis: CharacterBody2D
var player: CharacterBody2D
var victory_message: Label
var game_message: Label
var game_won: bool = false

func _ready():
	# Buscar referencias a los nodos importantes
	mantis = find_node_by_name("MantisEnemySimple")
	player = find_node_by_name("player1")
	victory_message = find_node_by_name("VictoryMessage")
	game_message = find_node_by_name("GameMessage")
	
	if mantis and mantis.has_signal("enemy_died"):
		mantis.enemy_died.connect(_on_mantis_died)
		print("Conectado a señal de muerte de mantis")
	else:
		print("Error: No se pudo conectar a la mantis")
	
	# Ocultar mensaje de victoria inicialmente
	if victory_message:
		victory_message.visible = false
	
	# Mostrar mensaje inicial por unos segundos
	if game_message:
		await get_tree().create_timer(3.0).timeout
		game_message.visible = false

func find_node_by_name(node_name: String) -> Node:
	return find_node_recursive(self, node_name)

func find_node_recursive(node: Node, target_name: String) -> Node:
	if node.name == target_name:
		return node
	
	for child in node.get_children():
		var result = find_node_recursive(child, target_name)
		if result:
			return result
	
	return null

func _on_mantis_died():
	print("¡Mantis derrotada! El jugador ha ganado")
	game_won = true
	show_victory()

func show_victory():
	if victory_message:
		victory_message.visible = true
		
		# Efecto de aparición gradual
		victory_message.modulate.a = 0.0
		var tween = create_tween()
		tween.tween_property(victory_message, "modulate:a", 1.0, 1.0)
	
	# Pausar el input del player (opcional)
	if player and player.has_method("set_physics_process"):
		player.set_physics_process(false)

func _input(event):
	if game_won and (event.is_action_pressed("ui_accept") or Input.is_key_pressed(KEY_ENTER)):
		# Volver al menú principal o escena anterior
		get_tree().change_scene_to_file("res://scenes/level9.tscn")

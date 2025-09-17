extends CharacterBody2D

# --- Configuración básica ---
const SPEED: float = 150.0
const MAX_HEALTH: int = 3
const ATTACK_RANGE: float = 150.0
const ATTACK_COOLDOWN: float = 1.2
const ATTACK_DAMAGE: int = 1

var health: int = MAX_HEALTH
var player_ref: CharacterBody2D = null
var can_attack: bool = true
var is_attacking: bool = false
var attack_timer: float = 0.0

var animated_sprite: AnimatedSprite2D

func _ready():
	find_player()
	animated_sprite = get_node_or_null("AnimatedSprite2D")
	if animated_sprite:
		animated_sprite.play("idle")
	if $AttackHitbox:
		$AttackHitbox.monitoring = false
		# Fuerza la máscara de colisión del hitbox solo a la capa 1
		for i in range(1, 21):
			$AttackHitbox.set_collision_mask_value(i, i == 1)
		if not $AttackHitbox.body_entered.is_connected(self._on_AttackHitbox_body_entered):
			$AttackHitbox.body_entered.connect(self._on_AttackHitbox_body_entered)

func _physics_process(delta):
	if health <= 0:
		return
	if player_ref:
		var dir = sign(player_ref.global_position.x - global_position.x)
		# Solo se mueve si no está atacando
		if not is_attacking:
			velocity.x = dir * SPEED
		else:
			velocity.x = 0
		# Ajusta el flip y la posición del hitbox de ataque
		if animated_sprite:
			animated_sprite.flip_h = dir < 0
		# Mueve el hitbox delante de la mantis según la dirección
		if $AttackHitbox:
			var offset = Vector2(55, 19)
			if dir < 0:
				offset.x *= -1
			$AttackHitbox.position = offset
		# Animación: solo cambia si no está atacando
		if animated_sprite:
			if is_attacking:
				if animated_sprite.animation != "Attack":
					animated_sprite.play("Attack")
			elif abs(velocity.x) > 10.0:
				if animated_sprite.animation != "walk":
					animated_sprite.play("walk")
			else:
				if animated_sprite.animation != "idle":
					animated_sprite.play("idle")
		move_and_slide()
		var dist = global_position.distance_to(player_ref.global_position)
		if dist < ATTACK_RANGE and can_attack and not is_attacking:
			start_attack()
	if is_attacking:
		attack_timer -= delta
		if attack_timer <= 0.0:
			finish_attack()

func start_attack():
	is_attacking = true
	can_attack = false
	# Duración igual a la animación de ataque (17 frames a 5 fps = 3.4s, pero puedes ajustar)
	attack_timer = 17.0 / 5.0
	if $AttackHitbox:
		$AttackHitbox.monitoring = true
		print("AttackHitbox monitoring: ", $AttackHitbox.monitoring)

func finish_attack():
	is_attacking = false
	if $AttackHitbox:
		$AttackHitbox.monitoring = false
	await get_tree().create_timer(ATTACK_COOLDOWN).timeout
	can_attack = true

func find_player():
	var scene_tree = get_tree()
	if scene_tree and scene_tree.current_scene:
		player_ref = find_player_recursive(scene_tree.current_scene)

func find_player_recursive(node: Node) -> CharacterBody2D:
	if node is CharacterBody2D and not node.is_in_group("enemy"):
		return node
	for child in node.get_children():
		var result = find_player_recursive(child)
		if result:
			return result
	return null

func take_damage(amount: int = 1) -> void:
	health -= amount
	if health <= 0:
		if animated_sprite:
			animated_sprite.play("death")
		await get_tree().create_timer(0.7).timeout
		queue_free()

func _on_AttackHitbox_body_entered(body):
	if body == self:
		return
	if is_attacking and body and body is CharacterBody2D and body.has_method("take_damage"):
		body.take_damage(ATTACK_DAMAGE)

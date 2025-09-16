extends CharacterBody2D

# Movimiento y combate
const SPEED: float = 300.0
const JUMP_VELOCITY: float = -400.0
const ACCELERATION: float = 800.0
const FRICTION: float = 600.0
const DASH_SPEED: float = 900.0
const DASH_DURATION: float = 0.15
const DASH_COOLDOWN: float = 0.3
const ATTACK_LOCK_MOVE: bool = true
const SLASH_DAMAGE: int = 1
const SLASH_HITBOX_SIZE: Vector2 = Vector2(60, 40)
const SLASH_HITBOX_OFFSET_X: float = 30.0
const MAX_HEALTH: int = 3
const INVULN_TIME: float = 0.8

# Física
var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))

# Estado
var is_jumping: bool = false
var is_running: bool = false
var facing_right: bool = true
var last_direction: float = 0.0
var is_dashing: bool = false
var dash_time_left: float = 0.0
var dash_cooldown_left: float = 0.0
var dash_key_down: bool = false
var is_attacking: bool = false
var mouse_attack_down: bool = false
var attack_time_left: float = 0.0
var invuln_time_left: float = 0.0

# Nodos
var animated_sprite: AnimatedSprite2D
var camera: Camera2D
var slash_hitbox: Area2D
var slash_shape: CollisionShape2D

# Animación
var current_animation: String = "idle"

func _ready():
	animated_sprite = find_sprite_node()
	
	if not animated_sprite:
		print("Error: No se encontró AnimatedSprite2D")
		return
	else:
		print("AnimatedSprite2D: ", animated_sprite.name)
	
	setup_camera()
	
	play_animation("idle")
	if animated_sprite:
		animated_sprite.flip_h = facing_right
		var cb := Callable(self, "_on_animation_finished")
		if not animated_sprite.animation_finished.is_connected(cb):
			animated_sprite.animation_finished.connect(cb)

	setup_slash_hitbox()

func setup_camera():
	camera = find_camera_node()
	
	if not camera:
		camera = Camera2D.new()
		camera.name = "Camera2D"
		add_child(camera)
		print("Cámara creada")
	else:
		print("Cámara: ", camera.name)
	
	camera.make_current()

func find_camera_node() -> Camera2D:
	return find_camera_recursive(self)

func find_camera_recursive(node: Node) -> Camera2D:
	if node is Camera2D:
		return node
	
	for child in node.get_children():
		var result = find_camera_recursive(child)
		if result:
			return result
	
	return null

func find_sprite_node() -> AnimatedSprite2D:
	if has_node("AnimatedSprite"):
		return $AnimatedSprite
	
	return find_animated_sprite_recursive(self)

func find_animated_sprite_recursive(node: Node) -> AnimatedSprite2D:
	if node is AnimatedSprite2D:
		return node

	for child in node.get_children():
		var result = find_animated_sprite_recursive(child)
		if result:
			return result

	return null

func print_children(node: Node, depth: int):
	var indent = ""
	for i in range(depth):
		indent += "  "
	print(indent + node.name + " (" + node.get_class() + ")")
	for child in node.get_children():
		print_children(child, depth + 1)

func _physics_process(delta: float) -> void:
	handle_timers(delta)
	if is_dashing:
		handle_dash(delta)
	else:
		handle_gravity(delta)
		handle_input(delta)
		if is_attacking and ATTACK_LOCK_MOVE:
			velocity.x = 0
		else:
			handle_movement(delta)
	update_animations(delta)
	move_and_slide()

func handle_timers(delta: float) -> void:
	if dash_cooldown_left > 0.0:
		dash_cooldown_left -= delta
		if dash_cooldown_left < 0.0:
			dash_cooldown_left = 0.0
	if is_attacking and attack_time_left > 0.0:
		attack_time_left -= delta
		if attack_time_left <= 0.0:
			end_attack()
	if invuln_time_left > 0.0:
		invuln_time_left -= delta
		if invuln_time_left < 0.0:
			invuln_time_left = 0.0

func handle_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta

func handle_input(delta: float) -> void:
	if (Input.is_action_just_pressed("ui_accept") or Input.is_key_pressed(KEY_SPACE)) and is_on_floor():
		velocity.y = JUMP_VELOCITY
		is_jumping = true
		play_animation("jump")

	var shift_down = Input.is_key_pressed(KEY_SHIFT)
	if shift_down and not dash_key_down and not is_dashing and dash_cooldown_left <= 0.0:
		start_dash()
	dash_key_down = shift_down

	var left_down := Input.is_mouse_button_pressed(MOUSE_BUTTON_LEFT)
	if left_down and not mouse_attack_down and not is_attacking and not is_dashing:
		start_attack()
	mouse_attack_down = left_down
	
	var input_dir = 0.0
	if Input.is_key_pressed(KEY_A):
		input_dir = -1.0
	elif Input.is_key_pressed(KEY_D):
		input_dir = 1.0
	
	if input_dir != 0:
		last_direction = input_dir
		if (input_dir > 0 and not facing_right) or (input_dir < 0 and facing_right):
			flip_character()
		
		velocity.x = move_toward(velocity.x, input_dir * SPEED, ACCELERATION * delta)
	else:
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)

func handle_movement(delta: float) -> void:
	var was_running = is_running
	is_running = abs(velocity.x) > 50.0 and is_on_floor()
	
	if was_on_air() and is_on_floor():
		is_jumping = false
		play_animation("land")
		await get_tree().create_timer(0.2).timeout
		if is_running:
			play_animation("run")
		else:
			play_animation("idle")

func was_on_air() -> bool:
	return is_jumping or not is_on_floor()

func flip_character():
	if animated_sprite == null:
		print("Error: sin AnimatedSprite2D")
		return
	facing_right = !facing_right
	animated_sprite.flip_h = facing_right

func start_dash():
	is_dashing = true
	dash_time_left = DASH_DURATION
	dash_cooldown_left = DASH_COOLDOWN
	var dir := 0.0
	if abs(velocity.x) > 0.0:
		dir = sign(velocity.x)
	elif facing_right:
		dir = 1.0
	else:
		dir = -1.0
	velocity.x = dir * DASH_SPEED
	play_animation("dash")

func handle_dash(delta: float) -> void:
	dash_time_left -= delta
	if dash_time_left <= 0.0:
		is_dashing = false
		if is_on_floor():
			if abs(velocity.x) > 10.0:
				play_animation("run")
			else:
				play_animation("idle")
		else:
			play_animation("jump")

func start_attack():
	is_attacking = true
	if ATTACK_LOCK_MOVE:
		velocity.x = 0
	play_animation("slash")
	activate_slash_hitbox()
	attack_time_left = 0.25
	if animated_sprite and animated_sprite.sprite_frames:
		var sf = animated_sprite.sprite_frames
		var frames := 0
		if sf.has_method("get_frame_count"):
			frames = sf.get_frame_count("slash")
		var speed := 10.0
		if sf.has_method("get_animation_speed"):
			speed = max(1.0, sf.get_animation_speed("slash"))
		elif frames > 0:
			speed = 10.0
		if frames > 0 and speed > 0.0:
			attack_time_left = float(frames) / speed

func _on_animation_finished():
	if current_animation == "slash":
		end_attack()

func end_attack():
	is_attacking = false
	attack_time_left = 0.0
	deactivate_slash_hitbox()
	if is_on_floor():
		if abs(velocity.x) > 10.0:
			play_animation("run")
		else:
			play_animation("idle")
	else:
		play_animation("jump")

func setup_slash_hitbox() -> void:
	if has_node("SlashHitbox"):
		slash_hitbox = $SlashHitbox
	else:
		slash_hitbox = Area2D.new()
		slash_hitbox.name = "SlashHitbox"
		add_child(slash_hitbox)
	if slash_hitbox.has_node("CollisionShape2D"):
		slash_shape = slash_hitbox.get_node("CollisionShape2D") as CollisionShape2D
	else:
		slash_shape = CollisionShape2D.new()
		slash_hitbox.add_child(slash_shape)
	var rect := RectangleShape2D.new()
	rect.size = SLASH_HITBOX_SIZE
	slash_shape.shape = rect
	slash_hitbox.monitoring = false
	slash_hitbox.monitorable = true
	var cb := Callable(self, "_on_slash_body_entered")
	if not slash_hitbox.body_entered.is_connected(cb):
		slash_hitbox.body_entered.connect(cb)

func activate_slash_hitbox() -> void:
	var dir_x := 1.0 if facing_right else -1.0
	slash_hitbox.position = Vector2(dir_x * SLASH_HITBOX_OFFSET_X, 0)
	slash_hitbox.set_deferred("monitoring", true)

func deactivate_slash_hitbox() -> void:
	slash_hitbox.monitoring = false

func _on_slash_body_entered(body: Node) -> void:
	if body == self:
		return
	if body.has_method("take_damage"):
		body.call("take_damage", SLASH_DAMAGE)
	elif body.is_in_group("enemy"):
		if body.has_method("die"):
			body.call("die")
		else:
			body.queue_free()

func take_damage(amount: int = 1) -> void:
	if invuln_time_left > 0.0 or is_dashing:
		return
	var new_health = max(0, get_health() - amount)
	set_health(new_health)
	if new_health <= 0:
		die()
		return
	invuln_time_left = INVULN_TIME

func get_health() -> int:
	if not has_meta("health"):
		set_meta("health", MAX_HEALTH)
	return int(get_meta("health"))

func set_health(v: int) -> void:
	set_meta("health", clamp(v, 0, MAX_HEALTH))

func die() -> void:
	get_tree().reload_current_scene()

func _on_spikes_body_entered(body: Node) -> void:
	if body is CharacterBody2D and body == self:
		die()

func update_animations(delta: float) -> void:
	if is_dashing or is_attacking:
		return
	
	if is_on_floor() and not is_jumping:
		if velocity.x != 0 and current_animation != "run":
			is_running = true
			play_animation("run")
		elif velocity.x == 0 and current_animation != "idle":
			is_running = false
			play_animation("idle")
	else:
		if current_animation != "jump":
			play_animation("jump")

func play_animation(anim_name: String):
	if animated_sprite == null:
		print("Error: sin AnimatedSprite2D")
		return
	
	if anim_name == current_animation:
		return
	
	if not animated_sprite.sprite_frames.has_animation(anim_name):
		print("Animación no existe: %s" % anim_name)
		return
	
	current_animation = anim_name
	
	animated_sprite.animation = anim_name
	animated_sprite.play()
	print("Anim: ", anim_name)

 

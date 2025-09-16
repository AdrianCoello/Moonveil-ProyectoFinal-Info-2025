extends CharacterBody2D

const SPEED: float = 350.0
const JUMP_VELOCITY: float = -450.0

var gravity: float = float(ProjectSettings.get_setting("physics/2d/default_gravity"))
var fps: int = 60

func _process(_delta: float) -> void:
	# Mantener cámara siempre activa
	if has_node("Camera2D"):
		$Camera2D.make_current()

	# Animaciones básicas
	if has_node("AnimatedSprite2D"):
		if is_on_floor():
			if velocity.x > 0.0:
				$AnimatedSprite2D.play("walk")
				$AnimatedSprite2D.flip_h = false
			elif velocity.x < 0.0:
				$AnimatedSprite2D.play("walk")
				$AnimatedSprite2D.flip_h = true
			else:
				$AnimatedSprite2D.play("default")
		else:
			if $AnimatedSprite2D.animation != "jump":
				$AnimatedSprite2D.play("jump")

	# Ajustar FPS → física más suave
	Engine.max_fps = int(DisplayServer.screen_get_refresh_rate())
	fps = Engine.get_frames_per_second()
	Engine.physics_ticks_per_second = fps

func _physics_process(delta: float) -> void:
	# Gravedad
	if !is_on_floor():
		velocity.y += gravity * delta

	# Salto normal
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		if has_node("Jump"):
			$Jump.play()

	# Movimiento lateral
	var direction := Input.get_axis("ui_left", "ui_right")
	if direction != 0.0:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)

	# Power-up 1: Wall jump / climb
	if Singleton.power_up_1 and is_on_wall() and Input.is_action_just_pressed("ui_accept"):
		velocity.y = JUMP_VELOCITY

	# Power-up 2: Escalar tamaño seguro
	if Singleton.power_up_2:
		if Input.is_action_just_pressed("scale_down"):
			if scale.x >= 0.2 and scale.y >= 0.2:
				scale -= Vector2(0.1, 0.1)

		if Input.is_action_just_pressed("scale_up"):
			var can_grow := true
			if has_node("RayUp") and $RayUp.is_colliding():
				can_grow = false
			if has_node("RayLeft") and $RayLeft.is_colliding():
				can_grow = false
			if has_node("RayRight") and $RayRight.is_colliding():
				can_grow = false
			if can_grow and scale.x <= 1.0 and scale.y <= 1.0:
				scale += Vector2(0.1, 0.1)

	move_and_slide()

# Llamado por spikes (signal body_entered)
func _on_spikes_body_entered(body: Node) -> void:
	if body is CharacterBody2D:
		if has_node("hit"):
			$hit.play()
			await $hit.finished
		get_tree().reload_current_scene()

extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_force: float = -250.0
@export var gravity: float = 900.0
@export var run_speed: float = 125.0
@export var run_jump_force: float = -275.0

var facing_direction: int = 1
var attacking: bool = false
var can_jump: bool = true

@onready var anim = $AnimatedSprite2D
@onready var walk_sound = $WalkSound
@onready var attack_sound = $AttackSound
@onready var camera = get_node("/root/TileMapLayer/Camera2D") if has_node("/root/TileMapLayer/Camera2D") else null

func _physics_process(delta):
	if not is_on_floor():
		velocity.y += gravity * delta

	var current_speed = speed
	var current_jump_force = jump_force

	if Input.is_action_pressed("move_shift"):
		current_speed = run_speed
		current_jump_force = run_jump_force

	var direction = 0
	if Input.is_action_pressed("move_right"):
		direction = 1
	elif Input.is_action_pressed("move_left"):
		direction = -1

	if direction != 0 and not attacking:
		velocity.x = direction * current_speed
		facing_direction = direction
		anim.flip_h = (facing_direction == -1)
		anim.play("walk")

		if not walk_sound.playing:
			walk_sound.play()
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		if is_on_floor() and not attacking:
			anim.play("idle")
		walk_sound.stop()

	if Input.is_action_just_pressed("move_jump") and is_on_floor() and can_jump:
		velocity.y = current_jump_force
		anim.play("jump")

	if velocity.y > 0 and not is_on_floor():
		anim.play("fall")

	if Input.is_action_just_pressed("attack") and not attacking and is_on_floor():
		attacking = true
		can_jump = false
		anim.play("attack")
		attack_sound.play()
		start_screen_shake(0.1, 5)
		await anim.animation_finished
		attacking = false
		can_jump = true

	move_and_slide()

# 🔥 Función para hacer el temblor de pantalla
func start_screen_shake(duration: float, intensity: float):
	if camera == null:
		return  

	var shake_timer = Timer.new()
	add_child(shake_timer)
	shake_timer.wait_time = duration
	shake_timer.one_shot = true
	shake_timer.timeout.connect(func():
		camera.offset = Vector2.ZERO
		shake_timer.queue_free()
	)
	shake_timer.start()

	for i in range(10):
		await get_tree().create_timer(duration / 10.0).timeout
		camera.offset = Vector2(randf_range(-intensity, intensity), randf_range(-intensity, intensity))

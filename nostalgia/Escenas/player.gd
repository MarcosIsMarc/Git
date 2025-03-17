extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_force: float = -250.0
@export var gravity: float = 900.0
@export var run_speed: float = 125.0  # Velocidad al correr
@export var run_jump_force: float = -275.0  # Salto al correr

var facing_direction: int = 1  # 1 para derecha, -1 para izquierda
var attacking: bool = false

@onready var anim = $AnimatedSprite2D  # Usamos AnimatedSprite2D

func _physics_process(delta):
	# Aplicar gravedad
	if not is_on_floor():
		velocity.y += gravity * delta

	# Definir velocidad y salto según si Shift está presionado
	var current_speed = speed
	var current_jump_force = jump_force

	if Input.is_action_pressed("move_shift"):  # Si Shift está presionado
		current_speed = run_speed
		current_jump_force = run_jump_force

	# Movimiento horizontal con A (derecha) y D (izquierda)
	var direction = 0
	if Input.is_action_pressed("move_right"):  # A -> Derecha
		direction = 1
	elif Input.is_action_pressed("move_left"):  # D -> Izquierda
		direction = -1

	if direction != 0 and not attacking:
		velocity.x = direction * current_speed
		facing_direction = direction
		anim.flip_h = (facing_direction == -1)  # Voltea el sprite si mira a la izquierda
		anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		if is_on_floor() and not attacking:
			anim.play("idle")

	# Saltar con W
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = current_jump_force
		anim.play("jump")

	# Animación de caída
	if velocity.y > 0 and not is_on_floor():
		anim.play("fall")
	
	# Ataque con la flecha derecha
	if Input.is_action_just_pressed("attack") and not attacking:
		attacking = true
		anim.play("attack")
		await anim.animation_finished  # Espera a que termine el ataque
		attacking = false

	move_and_slide()

extends CharacterBody2D

@export var speed: float = 100.0
@export var jump_force: float = -250.0
@export var gravity: float = 900.0
@export var run_speed: float = 125.0
@export var run_jump_force: float = -275.0

var facing_direction: int = 1
var attacking: bool = false
var can_jump: bool = true
var blocking: bool = false

@onready var anim = $AnimatedSprite2D

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

	if direction != 0 and not attacking and not blocking:
		velocity.x = direction * current_speed
		facing_direction = direction
		anim.flip_h = (facing_direction == -1)
		anim.play("walk")
	else:
		velocity.x = move_toward(velocity.x, 0, current_speed)
		if is_on_floor() and not attacking and not blocking:
			anim.play("idle")

	if Input.is_action_just_pressed("move_jump") and is_on_floor() and can_jump:
		velocity.y = current_jump_force
		anim.play("jump")

	if velocity.y > 0 and not is_on_floor():
		anim.play("fall")
	
	if Input.is_action_just_pressed("attack") and not attacking and is_on_floor():
		attacking = true
		can_jump = false
		anim.play("attack")
		await anim.animation_finished
		attacking = false
		can_jump = true

	if Input.is_action_pressed("block"):
		blocking = true
		anim.play("block")
		if anim.frame >= 8:
			anim.frame = 8
			anim.stop()
	else:
		if blocking and anim.animation == "block" and anim.frame == 8:
			anim.play()
		blocking = false

	move_and_slide()

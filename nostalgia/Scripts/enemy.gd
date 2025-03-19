extends CharacterBody2D

@export var speed: float = 190.0
@export var shoot_cooldown: float = 3.0
@export var gravity: float = 500.0
@export var patrol_speed: float = 30.0  # Velocidad de patrulla
@export var patrol_direction: int = -1.0  # Dirección inicial (-1 = izquierda, 1 = derecha)

var player = null
var attacking = false
var can_shoot = true

@onready var anim = $AnimatedSprite2D
@onready var shoot_timer = $ShootTimer
@onready var player_detector = $PlayerDetector
@onready var collision_shape = $CollisionShape2D  # Asegúrate de tener un CollisionShape2D
@onready var shoot_sound = $ShootSound

func _ready():
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.start()
	anim.flip_h = patrol_direction < 0  # Dirección inicial al cargar

func _physics_process(delta):
	apply_gravity(delta)

	if player:
		var distance = global_position.distance_to(player.global_position)
		if distance >= 50 and can_shoot:
			attack_shoot()
		else:
			move_towards_player()
	else:
		patrol()

	move_and_slide()

func apply_gravity(delta):
	if not is_on_floor():
		velocity.y += gravity * delta
	else:
		velocity.y = 0

func move_towards_player():
	if not attacking and is_on_floor():
		var direction = (player.global_position - global_position).normalized()
		velocity.x = direction.x * speed
		anim.flip_h = velocity.x < 0  # Voltear según la dirección del movimiento
		anim.play("walk")
	else:
		velocity.x = 0

func attack_shoot():
	attacking = true
	can_shoot = false
	velocity = Vector2.ZERO
	anim.play("shoot_attack")
	shoot_sound.play()
	await anim.animation_finished
	shoot_timer.start()
	
	attacking = false

func patrol():
	if is_on_floor():
		# Movimiento de patrulla automático
		velocity.x = patrol_direction * patrol_speed
		anim.play("walk")
		anim.flip_h = patrol_direction < 0  # Voltear según la dirección de patrulla
	else:
		velocity.x = 0
		anim.play("fall")  # Animación de caída

# Invierte la dirección de patrulla al chocar con una pared
func _on_wall_detector_body_entered(body):
	if body.is_in_group("walls"):
		patrol_direction *= -1

func _on_shoot_timer_timeout():
	can_shoot = true

func _on_player_detector_body_entered(body):
	if body.is_in_group("player"):
		player = body

func _on_player_detector_body_exited(body):
	if body == player:
		player = null

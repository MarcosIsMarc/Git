extends CharacterBody2D

@export var speed: float = 50.0
@export var attack_range: float = 30.0
@export var random_move_time: float = 2.0
@export var idle_time: float = 1.5  # Tiempo en que el enemigo se queda quieto antes de moverse otra vez

var player: CharacterBody2D = null
var direction: int = 1  # 1 para derecha, -1 para izquierda
var moving_randomly: bool = true
var is_idle: bool = false

@onready var anim = $AnimatedSprite2D
@onready var vision_area = $Area2D

func _ready():
	vision_area.body_entered.connect(_on_area_2d_body_entered)
	vision_area.body_exited.connect(_on_area_2d_body_exited)
	
	# Comienza el movimiento aleatorio
	random_movement()

func _physics_process(delta):
	if is_idle:
		velocity.x = 0
		anim.play("idle")
		return

	if moving_randomly:
		velocity.x = direction * speed
		anim.play("walk")
	else:
		if player:
			var distance = player.global_position.distance_to(global_position)
			if distance > attack_range:
				velocity.x = sign(player.global_position.x - global_position.x) * speed
				anim.play("walk")
			else:
				velocity.x = 0
				anim.play("attack")

	# Girar el sprite según la dirección
	if velocity.x != 0:
		anim.flip_h = velocity.x < 0

	move_and_slide()

func random_movement():
	while moving_randomly:
		await get_tree().create_timer(random_move_time).timeout
		if moving_randomly:  # Verifica si sigue en movimiento aleatorio
			velocity.x = 0
			anim.play("idle")
			is_idle = true
			await get_tree().create_timer(idle_time).timeout  # Pausa en Idle antes de cambiar dirección
			is_idle = false
			direction *= -1  # Cambia de dirección

func _on_area_2d_body_entered(body: Node2D) -> void:
	if body is CharacterBody2D:
		player = body
		moving_randomly = false  # Deja de moverse aleatoriamente
		is_idle = false  # No entra en idle si está persiguiendo

func _on_area_2d_body_exited(body: Node2D) -> void:
	if body == player:
		player = null
		is_idle = true
		await get_tree().create_timer(idle_time).timeout  # Hace una pausa en Idle antes de patrullar
		is_idle = false
		moving_randomly = true  # Reanuda el movimiento aleatorio

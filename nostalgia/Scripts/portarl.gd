extends Area2D

@onready var anim = $AnimatedSprite2D
@onready var portal_sound = $PortalSound
@export var nueva_escena: String = "res://Escenas/campo_batalla.tscn"
var jugador_dentro = false

func _ready() -> void:
	anim.play("portal")

func _on_body_entered(body):
	if body is CharacterBody2D:
		jugador_dentro = true  

func _on_body_exited(body):
	if body is CharacterBody2D:
		jugador_dentro = false  

func _process(_delta):
	if jugador_dentro and Input.is_action_just_pressed("interactuar"):
		portal_sound.play()
		start_transition()

# 🔥 Función para hacer la transición
func start_transition():
	var canvas = CanvasLayer.new()  
	var color_rect = ColorRect.new()
	canvas.add_child(color_rect)
	add_child(canvas)

	# Ajustes del ColorRect (pantalla negra)
	color_rect.color = Color.BLACK
	color_rect.size = get_viewport_rect().size
	color_rect.modulate.a = 0  # Transparente al inicio

	# Animación de fundido
	var tween = get_tree().create_tween()
	tween.tween_property(color_rect, "modulate:a", 1, 0.5)  # Se oscurece en 0.5 seg
	await tween.finished  
	get_tree().change_scene_to_file(nueva_escena)

	# Fundido de regreso en la nueva escena

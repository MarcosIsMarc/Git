extends Area2D

@onready var anim = $AnimatedSprite2D
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	anim.play("portal")

	

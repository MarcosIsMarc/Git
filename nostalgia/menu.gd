extends Control

@onready var fade_rect = $ScreenFade  # Referencia al ColorRect

func _ready():
	fade_rect.modulate.a = 1  # Inicia completamente negro
	fade_out()  # Hace la transición de entrada

func fade_out():
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0, 0.5)  # Desvanece en 0.5s

func fade_in(callback: Callable):
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1, 0.5)  # Oscurece en 0.5s
	await tween.finished
	callback.call()

func _on_start_pressed() -> void:
	fade_in(func(): get_tree().change_scene_to_file("res://Escenas/world.tscn"))

func _on_exit_pressed() -> void:
	fade_in(func(): get_tree().quit())

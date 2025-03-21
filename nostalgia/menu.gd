extends Control

@onready var fade_rect = $ScreenFade  # Referencia al ColorRect
@export var nueva_escena: String = "res://Escenas/world.tscn"  # Escena a cargar

# Función para realizar el fundido de entrada (fade in)
func fade_in(on_fade_complete: Callable):
	# Asegurarse de que el ColorRect esté visible y transparente al inicio
	fade_rect.visible = true
	fade_rect.modulate.a = 0

	# Animación de fundido de entrada (oscurecer)
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1, 0.5)  # Se oscurece en 0.5 segundos
	await tween.finished

	# Ejecutar la acción después del fundido (cambiar de escena o salir del juego)
	on_fade_complete.call()

# Función para realizar el fundido de salida (fade out)
func fade_out():
	# Asegurarse de que el ColorRect esté visible y opaco al inicio
	fade_rect.visible = true
	fade_rect.modulate.a = 1

	# Animación de fundido de salida (aclarar)
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 0, 0.5)  # Se aclara en 0.5 segundos
	await tween.finished

	# Ocultar el ColorRect después del fundido
	fade_rect.visible = false

# Función para cambiar de escena con fundido
func _on_start_pressed() -> void:
	fade_in(func(): 
		get_tree().change_scene_to_file(nueva_escena)  # Cambiar de escena
	)

# Función para salir del juego con fundido
func _on_exit_pressed() -> void:
	fade_in(func(): 
		get_tree().quit()  # Salir del juego
	)

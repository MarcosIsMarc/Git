extends TileMapLayer

@onready var fade_rect = $ScreenFade  # Referencia al ColorRect

# Función para realizar el fundido de entrada (fade in)
func fade_in():
	# Asegurarse de que el ColorRect esté visible y transparente al inicio
	fade_rect.visible = true
	fade_rect.modulate.a = 0

	# Animación de fundido de entrada (oscurecer)
	var tween = get_tree().create_tween()
	tween.tween_property(fade_rect, "modulate:a", 1, 0.5)  # Se oscurece en 0.5 segundos
	await tween.finished

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

# Función para iniciar la transición al entrar al TileMapLayer
func start_transition():
	await fade_in()  # Oscurecer la pantalla
	# Aquí puedes hacer cambios en el TileMapLayer (por ejemplo, cargar un nuevo nivel)
	await fade_out()  # Aclarar la pantalla

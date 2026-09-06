extends enemigo

@export var velocidad_dash: float = 2000.0
@export var duracion_dash: float = 0.25
@export var tiempo_entre_dash: float = 2.0

var haciendo_dash: bool = false
var puede_hacer_dash: bool = true
var direccion_dash: Vector2 = Vector2.ZERO
var tiempo_preparacion_dash: float = 1.0
var preparando_dash: bool = false

#variables shader
var tiempo_actual_duplicado: float = 0
var tiempo_duplicado: float = 0.005
var tiempo_vida_duplicado: float = 0.2


func _physics_process(delta):

	if haciendo_dash:

		return

	super._physics_process(delta)

	if persiguiendo and puede_hacer_dash and not preparando_dash:

		if global_position.distance_to(jugador.global_position) < 700:

			preparar_dash()


func preparar_dash() -> void:

	preparando_dash = true

	await get_tree().create_timer(tiempo_preparacion_dash).timeout

	if persiguiendo and jugador != null:

		hacer_dash()

	preparando_dash = false


func hacer_dash() -> void:

	if jugador == null:

		return

	puede_hacer_dash = false

	var tipo_dash = randi_range(0, 3)

	match tipo_dash:

		0:
			await dash_normal()

		1:
			await doble_dash()

		2:
			await dash_zigzag()

		3:
			await dash_parabola()

	haciendo_dash = false
	velocity = Vector2.ZERO

	await get_tree().create_timer(tiempo_entre_dash).timeout

	puede_hacer_dash = true

func dash_normal() -> void:

	if jugador == null:
		return

	haciendo_dash = true

	var _direccion = global_position.direction_to(jugador.global_position)

	await mover_dash(direccion, duracion_dash)

func doble_dash() -> void:

	if jugador == null:
		return

	haciendo_dash = true

	var _direccion = global_position.direction_to(jugador.global_position)

	await mover_dash(direccion, duracion_dash * 0.5)

	await get_tree().create_timer(0.08).timeout

	if jugador == null:
		return

	direccion = global_position.direction_to(jugador.global_position)

	var _angulo = randf_range(-70.0, 70.0)

	direccion = direccion.rotated(deg_to_rad(angulo))

	await mover_dash(direccion, duracion_dash * 0.5)

func dash_zigzag() -> void:

	if jugador == null:
		return

	haciendo_dash = true

	var _direccion = global_position.direction_to(jugador.global_position)

	var perpendicular = Vector2(-direccion.y, direccion.x)

	if randf() > 0.5:
		perpendicular *= -1

	var cantidad_zigzags = 4
	var duracion_por_dash = duracion_dash / cantidad_zigzags

	for i in range(cantidad_zigzags):

		var direccion_actual: Vector2

		if i % 2 == 0:
			direccion_actual = direccion + perpendicular * 0.8
		else:
			direccion_actual = direccion - perpendicular * 0.8

		await mover_dash(direccion_actual.normalized(),duracion_por_dash)

func dash_parabola() -> void:

	if jugador == null:
		return

	haciendo_dash = true

	var _direccion = global_position.direction_to(jugador.global_position)

	var perpendicular = Vector2(-direccion.y, direccion.x)

	if randf() > 0.5:
		perpendicular *= -1

	var tiempo := 0.0

	while tiempo < duracion_dash:

		var t = tiempo / duracion_dash

		var curva = 4.0 * t * (1.0 - t)

		var direccion_actual = direccion + perpendicular * curva * 2.0

		velocity = direccion_actual.normalized() * velocidad_dash

		move_and_slide()

		crear_duplicado_shader()

		await get_tree().create_timer(tiempo_duplicado).timeout

		tiempo += tiempo_duplicado

func mover_dash(_direccion: Vector2, duracion: float) -> void:

	direccion_dash = direccion.normalized()

	var tiempo_transcurrido := 0.0

	while tiempo_transcurrido < duracion:

		velocity = direccion_dash * velocidad_dash

		move_and_slide()

		crear_duplicado_shader()

		await get_tree().create_timer(tiempo_duplicado).timeout

		tiempo_transcurrido += tiempo_duplicado

func crear_duplicado_shader() -> void:

	var duplicado = $AnimatedSprite2D.duplicate(false)

	if $AnimatedSprite2D.material:

		duplicado.material = $AnimatedSprite2D.material.duplicate(true)

		duplicado.material.set_shader_parameter("opacity", 1.0)
		duplicado.material.set_shader_parameter("r", 1.0)
		duplicado.material.set_shader_parameter("g", 1.0)
		duplicado.material.set_shader_parameter("b", 1.0)
		duplicado.material.set_shader_parameter("mix_color", 1.0)

	var posicion_duplicado = global_position

	get_parent().add_child(duplicado)

	duplicado.global_position = posicion_duplicado
	duplicado.global_scale = $AnimatedSprite2D.global_scale
	duplicado.z_index = 1

	estelas.append(duplicado)

	await get_tree().create_timer(tiempo_vida_duplicado).timeout

	estelas.erase(duplicado)

	if is_instance_valid(duplicado):
		duplicado.queue_free()

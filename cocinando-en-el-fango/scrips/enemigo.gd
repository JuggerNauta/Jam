class_name enemigo
extends CharacterBody2D

#patrulla del coso que se mueva (esta que me cuelga)

@export var waypoints: Array[Marker2D]
@export var velocidad: float = 200.0

var direccion := Vector2.ZERO
var posiciones_waypoints: Array[Vector2] = []
var current_index: int = 0
var esta_esperando: bool = false
	

#señales

signal enemigo_murio(enemigo)

var estelas: Array[Node2D] = []

#animaciones

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var ultima_direccion_personaje: String = "abajo"

#variables para la deteccion del jugador

@onready var navigation_agent_2d: NavigationAgent2D = $NavigationAgent2D
@onready var ray_cast_2d: RayCast2D = $RayCast2D

@export var angulo: float = 120.0
@export var largo: float = 2000.0
@export var tiempo_busqueda: float = 2.0

var direccion_detector := Vector2.DOWN
var mitad_angulo_radiales: float
var jugador: Node2D = null
var persiguiendo: bool = false
var tiempo_perdiendo_jugador: float = 0.0

#variable vida

@export var vida: float = 3.0
@export var daño: float = 1.0

#recibir daño no se q mas poner, no se stun y notback? no se cmo se escibre notback

@export var tiempo_aturdido: float = 1.0
@export var fuerza_empuje: float = 100.0

var aturdido: bool = false

func _ready() -> void:

	$Area2D.body_entered.connect(_on_area_2d_body_entered)

	jugador = get_tree().get_first_node_in_group("jugador")
	mitad_angulo_radiales = deg_to_rad(angulo / 2.0)

	add_to_group("enemigo")

	posiciones_waypoints.clear()

	for waypoint in waypoints:

		if waypoint != null:
			posiciones_waypoints.append(waypoint.global_position)

	queue_redraw()

func _draw() -> void:

	var izquierda_direccion = direccion_detector.rotated(-mitad_angulo_radiales) * largo

	var derecha_direccion = direccion_detector.rotated(mitad_angulo_radiales) * largo

	draw_line(Vector2.ZERO,izquierda_direccion,Color.WHITE,0.0)
	draw_line(Vector2.ZERO,derecha_direccion,Color.WHITE,0.0)

func esta_en_el_cono() -> bool:

	if jugador == null:

		return false

	var posicion_local_jugador: Vector2 = to_local(jugador.global_position)

	var distancia: float = posicion_local_jugador.length()

	if distancia > largo:

		return false

	if distancia < 5.0:

		return true

	var angulo_hacia_jugador: float = direccion_detector.angle_to(posicion_local_jugador)

	return abs(angulo_hacia_jugador) <= mitad_angulo_radiales

func _physics_process(delta: float) -> void:

	if aturdido:
		move_and_slide()
		return

	var _puede_ver_jugador = esta_en_el_cono() and tiene_linea_de_señal()

	if esta_en_el_cono() and tiene_linea_de_señal():
		animated_sprite_2d.self_modulate = Color.WHITE

	else:
		animated_sprite_2d.self_modulate = Color.WHITE

	if jugador == null:

		patrullar()

		return

	if not persiguiendo:

		if esta_en_el_cono():
			persiguiendo = true
			tiempo_perdiendo_jugador = 0.0

			perseguir_jugador()

		else:
			patrullar()

		return

	if persiguiendo:

		if esta_en_el_cono():
			tiempo_perdiendo_jugador = 0.0

		else:
			tiempo_perdiendo_jugador += delta

		if tiempo_perdiendo_jugador >= tiempo_busqueda:
			persiguiendo = false
			tiempo_perdiendo_jugador = 0.0
			velocity = Vector2.ZERO

			patrullar()

			return

		perseguir_jugador()

func perseguir_jugador() -> void:

	if jugador == null:
		persiguiendo = false
		velocity = Vector2.ZERO

		return

	navigation_agent_2d.target_position = jugador.global_position

	direccion = to_local(navigation_agent_2d.get_next_path_position()).normalized()
	velocity = direccion * velocidad

	actualizar_direccion(direccion)

	actualizar_animacion("caminar")

	move_and_slide()

func patrullar() -> void:

	if posiciones_waypoints.is_empty():
		velocity = Vector2.ZERO

		return

	if esta_esperando:
		velocity = Vector2.ZERO

		return

	if current_index >= posiciones_waypoints.size():
		current_index = 0

	var posicion_señalada: Vector2 = posiciones_waypoints[current_index]

	direccion = posicion_señalada - global_position

	var distancia: float = direccion.length()
	var distancia_minima: float = 5.0

	if distancia <= distancia_minima:
		velocity = Vector2.ZERO
		current_index += 1

		if current_index >= posiciones_waypoints.size():
			current_index = 0
		esta_esperando = true
		$Timer.start()

		return

	direccion = direccion.normalized()
	velocity = direccion * velocidad

	actualizar_direccion(direccion)

	actualizar_animacion("caminar")

	move_and_slide()

func actualizar_direccion(nueva_direccion: Vector2) -> void:

	if nueva_direccion == Vector2.ZERO:
		return

	if abs(nueva_direccion.x) > abs(nueva_direccion.y):

		if nueva_direccion.x > 0:
			ultima_direccion_personaje = "derecha"
			direccion_detector = Vector2.RIGHT

		else:
			ultima_direccion_personaje = "izquierda"
			direccion_detector = Vector2.LEFT

	else:

		if nueva_direccion.y > 0:

			ultima_direccion_personaje = "abajo"
			direccion_detector = Vector2.DOWN

		else:
			ultima_direccion_personaje = "arriba"
			direccion_detector = Vector2.UP

	queue_redraw()

func actualizar_animacion(estado: String) -> void:

	var animacion: String = (estado + "_" + ultima_direccion_personaje)

	if animated_sprite_2d.animation != animacion:
		animated_sprite_2d.play(animacion)

func _on_timer_timeout() -> void:

	esta_esperando = false

	if jugador == null:

		return

	navigation_agent_2d.target_position = jugador.global_position

func recibir_daño(daño_arma: float) -> void:

	$AnimatedSprite2D/AnimationPlayer.play("tomando_daño")
	vida -= daño_arma

	aturdido = true

	var direccion_empuje = (global_position - jugador.global_position).normalized()

	velocity = direccion_empuje * fuerza_empuje

	await get_tree().create_timer(tiempo_aturdido).timeout

	aturdido = false

	if vida <= 0.0:
		morirse()

func morirse() -> void:

	# Eliminar todas las estelas
	for estela in estelas:
		if is_instance_valid(estela):
			estela.queue_free()

	estelas.clear()

	enemigo_murio.emit(self)
	queue_free()

func _on_area_2d_body_entered(body: Node2D) -> void:

	if body.is_in_group("jugador"):
		body.recibir_daño(daño)

func rayo_deteccion():

	if jugador == null:
		return

	ray_cast_2d.target_position = to_local(jugador.position)
	ray_cast_2d.force_raycast_update()

func tiene_linea_de_señal() -> bool:

	if jugador == null:
		return false

	ray_cast_2d.target_position = to_local(jugador.global_position)
	ray_cast_2d.force_raycast_update()

	if not ray_cast_2d.is_colliding():
		return false

	var colision = ray_cast_2d.get_collider()

	if colision == null:
		return false

	return colision.is_in_group("jugador")

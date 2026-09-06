class_name enemigo
extends CharacterBody2D



#variables para el ruta de movimiento
@export var waypoints: Array[Marker2D]
@export var velocidad: float = 200.0

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

var ultima_direccion_personaje: String = "abajo"
var current_index = 0
var esta_esperando = false

#variables para que detecte al jugador
@export var angulo: float = 120
@export var largo: float = 2000

var direccion_detector = Vector2.DOWN
var mitad_angulo_radiales 
var jugador 
var persiguiendo = false

#enemigo vida
var vida: float = 3.0

func _ready() -> void:
	jugador = get_tree().get_first_node_in_group("jugador")
	mitad_angulo_radiales = deg_to_rad(angulo / 2)
	add_to_group("enemigo")

func _draw(): #nomas para ver si funciona
	var izquierda_direccion = direccion_detector.rotated(-mitad_angulo_radiales) * largo
	var derecha_direccion = direccion_detector.rotated(mitad_angulo_radiales) * largo

	draw_line(Vector2.ZERO, izquierda_direccion, Color.YELLOW, 2.0)
	draw_line(Vector2.ZERO, derecha_direccion, Color.YELLOW, 2.0)

func esta_en_el_cono():
	
	if jugador == null:
		return false
		
	var posicion_local_jugador = to_local(jugador.global_position)
	var angulo_hacia_jugador = direccion_detector.angle_to(posicion_local_jugador)
	var distancia = posicion_local_jugador.length()
	
	if distancia > largo:
		return false

	return abs(angulo_hacia_jugador) <= mitad_angulo_radiales


func _physics_process(_delta):

	var direccion = Vector2.ZERO

	#detecta al mongolo del sapo
	if esta_en_el_cono():
		persiguiendo = true
		animated_sprite_2d.self_modulate = Color.RED
	else:
		animated_sprite_2d.self_modulate = Color.WHITE

	#persigue al jugador
	if persiguiendo:

		direccion = (jugador.global_position - global_position).normalized()
		velocity = direccion * velocidad

		#donde mira
		if abs(direccion.x) > abs(direccion.y):

			if direccion.x > 0:
				ultima_direccion_personaje = "derecha"
				direccion_detector = Vector2.RIGHT
			else:
				ultima_direccion_personaje = "izquierda"
				direccion_detector = Vector2.LEFT

		else:

			if direccion.y > 0:
				ultima_direccion_personaje = "abajo"
				direccion_detector = Vector2.DOWN
			else:
				ultima_direccion_personaje = "arriba"
				direccion_detector = Vector2.UP

		queue_redraw()
		actualizar_animacion("caminar")
		move_and_slide()

		# ya no ve al jugador?, que pena se va
		if not esta_en_el_cono():
			persiguiendo = false

		return

	#movimiento tipo patrulla, que vaya de un lado a otro
	if esta_esperando:
		return

	var distancia_minima = 5.0
	var posicion_señalada = waypoints[current_index].global_position

	direccion = posicion_señalada - global_position
	var distancia = direccion.length()

	if distancia < distancia_minima:

		current_index += 1
		velocity = Vector2.ZERO

		$Timer.start()

		esta_esperando = true

		if current_index >= waypoints.size():
			current_index = 0

		return

	#moverse hacia el waypoin
	direccion = direccion.normalized()

	velocity = direccion * velocidad

	#direccion enemigo
	if abs(direccion.x) > abs(direccion.y):

		if direccion.x > 0:
			ultima_direccion_personaje = "derecha"
			direccion_detector = Vector2.RIGHT
		else:
			ultima_direccion_personaje = "izquierda"
			direccion_detector = Vector2.LEFT

	else:

		if direccion.y > 0:
			ultima_direccion_personaje = "abajo"
			direccion_detector = Vector2.DOWN
		else:
			ultima_direccion_personaje = "arriba"
			direccion_detector = Vector2.UP


	queue_redraw()

	actualizar_animacion("caminar")

	move_and_slide()

func actualizar_animacion(estado: String) -> void:

	var animacion = estado + "_" + ultima_direccion_personaje
	if animated_sprite_2d.animation != animacion:

			animated_sprite_2d.play(animacion)

func _on_timer_timeout() -> void:
	esta_esperando = false

func recibir_daño(daño_arma: float): 
	$AnimatedSprite2D/AnimationPlayer.play("tomando_daño") 
	vida -= daño_arma 
	 
	if vida <= 0.0: 
		queue_free()

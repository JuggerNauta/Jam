extends enemigo

@export var velocidad_dash: float = 2000.0
@export var duracion_dash: float = 0.25
@export var tiempo_entre_dash: float = 2.0

var haciendo_dash: bool = false
var puede_hacer_dash: bool = true
var direccion_dash: Vector2 = Vector2.ZERO
var tiempo_preparacion_dash: float = 1.0
var preparando_dash: bool = false

func _physics_process(delta):

	if haciendo_dash:
		velocity = direccion_dash * velocidad_dash
		move_and_slide()
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
	direccion_dash = global_position.direction_to(jugador.global_position)
	haciendo_dash = true

	await get_tree().create_timer(duracion_dash).timeout

	haciendo_dash = false
	velocity = Vector2.ZERO

	await get_tree().create_timer(tiempo_entre_dash).timeout

	puede_hacer_dash = true

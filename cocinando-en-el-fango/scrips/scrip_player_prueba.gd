extends CharacterBody2D

@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

@onready var espada: Node2D = $AnimatedSprite2D/espada
@onready var espada_sprite: Sprite2D = $AnimatedSprite2D/espada/espada_sprite
@onready var espada_animation_player: AnimationPlayer = $AnimatedSprite2D/espada/espada_sprite/AnimationPlayer


#movimiento variables

@export var velocidad: float = 200.0

var ultima_direccion_personaje: String = "abajo"
var ultima_direccion: Vector2 = Vector2.ZERO


#atacar variables

@export var tiempo_ataque: float = 0.2
@export var tiempo_espada_regresa: float = 0.5
@export var daño_arma: float = 1.0

var puedo_atacar: bool = true
var actual_vista_dir: String = "derecha"

const espada_ataque_preload = preload("res://escenas/espada_ataque.tscn")

#dash variables

@export var dash_velocidad: float = 1500.0
@export var dash_tiempo: float = 0.12
@export var dash_costo_recarga: float = 0.2

var puedo_dash: bool = true
var dash_timer: float = 0.0
var dash_timer_recarga: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO


func _physics_process(delta: float) -> void:

	_dash_logica(delta)

	if dash_timer <= 0.0:
		get_input()

	seguir_espada()

	atacar()

	move_and_slide()

#atacar
func _ready() -> void:
	add_to_group("jugador")

func seguir_espada() -> void:

	var direccion = get_global_mouse_position() - global_position
	espada.rotation = direccion.angle()

	var angulo = direccion.angle()

	espada.rotation = angulo

	if angulo > PI / 2 or angulo < -PI / 2:
		espada_sprite.flip_v = true
	else:
		espada_sprite.flip_v = false

	if get_global_mouse_position().y > global_position.y:
		espada.show_behind_parent = false
	else:
		espada.show_behind_parent = true


func atacar() -> void:

	if Input.is_action_just_pressed("ataque") and puedo_atacar:

		puedo_atacar = false
		espada_animation_player.play("ataque")
		spawnear_ataque()
		await get_tree().create_timer(tiempo_ataque).timeout

func spawnear_ataque() -> void:

	var espada_ataque = espada_ataque_preload.instantiate()
	espada_ataque.global_position = global_position
	var animation_player: AnimationPlayer = espada_ataque.get_node("Sprite2D/AnimationPlayer")
	var animacion = animation_player.get_animation("ataque")
	animation_player.speed_scale = animacion.length / tiempo_ataque
	var mirando_derecha = get_global_mouse_position().x > global_position.x
	espada_ataque.get_node("Sprite2D").flip_v = not mirando_derecha
	espada_ataque.daño_arma = daño_arma
	
	get_parent().add_child(espada_ataque)

func _on_animation_player_animation_finished(anim_name: StringName) -> void:

	if anim_name == "ataque":
		var animacion_regreso = espada_animation_player.get_animation("ataque_regreso")

		espada_animation_player.speed_scale = animacion_regreso.length / tiempo_espada_regresa

		espada_animation_player.play("ataque_regreso")

	elif anim_name == "ataque_regreso":

		puedo_atacar = true

#movimiento

func get_input() -> void:
	var direccion := Vector2.ZERO

	# Movimiento vertical
	if Input.is_action_pressed("abajo"):
		direccion += transform.y

	if Input.is_action_pressed("arriba"):
		direccion -= transform.y

	# Movimiento horizontal
	if Input.is_action_pressed("izquierda"):
		direccion -= transform.x

	if Input.is_action_pressed("derecha"):
		direccion += transform.x

	# Si hay movimiento
	if direccion != Vector2.ZERO:

		direccion = direccion.normalized()
		ultima_direccion = direccion

	# Si no se está moviendo
	if direccion == Vector2.ZERO:

		velocity = Vector2.ZERO
		actualizar_animacion("idle")
		return

	if abs(direccion.x) > abs(direccion.y):

		if direccion.x > 0:
			ultima_direccion_personaje = "derecha"
		else:
			ultima_direccion_personaje = "izquierda"

	else:
		if direccion.y > 0:
			ultima_direccion_personaje = "abajo"
		else:
			ultima_direccion_personaje = "arriba"

	actualizar_animacion("caminar")
	velocity = direccion * velocidad


#animaciones del personaje (me quiero pegar un tiro en el huevo, ayuda)

func actualizar_animacion(estado: String) -> void:

	var animacion = estado + "_" + ultima_direccion_personaje
	if animated_sprite_2d.animation != animacion:

		animated_sprite_2d.play(animacion)

#dash

func _dash_logica(delta: float) -> void:


	if puedo_dash and Input.is_action_just_pressed("dash"):
		puedo_dash = false
		dash_timer = dash_tiempo
		dash_timer_recarga = dash_costo_recarga
		dash_dir = ultima_direccion
		velocity = dash_dir * dash_velocidad

	if dash_timer > 0.0:
		dash_timer = max(0.0, dash_timer - delta)
	else:
		if dash_timer_recarga > 0.0:
			dash_timer_recarga -= delta
		else:

			puedo_dash = true
			
func clamp_to_limits(limit_pos: Vector2, limit_size: Vector2):
	global_position.x = clamp(global_position.x, limit_pos.x + 16, limit_pos.x + limit_size.x -8)
	global_position.y = clamp(global_position.y, limit_pos.y + 32, limit_pos.y + limit_size.y -8)
	

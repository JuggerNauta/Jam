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
@export var tiempo_espada_regresa: float = 0.3
@export var daño_arma: float = 1.0

var puedo_atacar: bool = true
var actual_vista_dir: String = "derecha"

const espada_ataque_preload = preload("res://escenas/espada_ataque.tscn")

#dash variables

@export var dash_velocidad: float = 2500.0
@export var dash_tiempo: float = 0.12
@export var dash_costo_recarga: float = 0.2

var puedo_dash: bool = true
var dash_timer: float = 0.0
var dash_timer_recarga: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO

#variables vida

signal vida_cambiada(actual: float, maxima: float)

@export var vida_maxima: float = 10.0
var vida: float = vida_maxima
var esta_muriendo: bool = false

#variables shader

var tiempo_actual_duplicado: float = 0
var tiempo_duplicado: float = 0.05
var tiempo_vida_duplicado: float = 0.2

func _physics_process(delta: float) -> void:

	tiempo_actual_duplicado += delta

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

	if ultima_direccion != Vector2.ZERO:
		espada.rotation = ultima_direccion.angle()

	if ultima_direccion.y > 0:
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
	
	var distancia_ataque := 0.0

	espada_ataque.global_position = global_position + ultima_direccion * distancia_ataque
	espada_ataque.global_rotation = espada.global_rotation

	var animation_player: AnimationPlayer = espada_ataque.get_node("Sprite2D/AnimationPlayer")
	var animacion = animation_player.get_animation("ataque")

	animation_player.speed_scale = animacion.length / tiempo_ataque

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

	if Input.is_action_pressed("abajo"):
		direccion += transform.y

	if Input.is_action_pressed("arriba"):
		direccion -= transform.y

	if Input.is_action_pressed("izquierda"):
		direccion -= transform.x

	if Input.is_action_pressed("derecha"):
		direccion += transform.x

	if direccion != Vector2.ZERO:

		direccion = direccion.normalized()
		ultima_direccion = direccion

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

	#cuando el coso este jugador se meta el dado para el dash
	if dash_timer > 0.0:

		dash_timer = max(0.0, dash_timer - delta)

		tiempo_actual_duplicado += delta

		if tiempo_actual_duplicado >= tiempo_duplicado:
			tiempo_actual_duplicado = 0.0
			crear_duplicado_shader()

	else:

		if dash_timer_recarga > 0.0:
			dash_timer_recarga -= delta

		else:
			puedo_dash = true

func recibir_daño(cantidad: int) -> void:
	
	$AnimatedSprite2D/AnimationPlayer.play("recibir_daño")

	animated_sprite_2d.material.set_shader_parameter("r", 1.0)
	animated_sprite_2d.material.set_shader_parameter("g", 1.0)
	animated_sprite_2d.material.set_shader_parameter("b", 1.0)
	animated_sprite_2d.material.set_shader_parameter("mix_color", 1.0)
	animated_sprite_2d.material.set_shader_parameter("opacity", 1.0)

	await get_tree().create_timer(0.15).timeout

	animated_sprite_2d.material.set_shader_parameter("mix_color", 0.0)
	animated_sprite_2d.material.set_shader_parameter("opacity", 1.0)
	
	if esta_muriendo:
		return

	vida = max(vida - cantidad, 0.0)
	vida_cambiada.emit(vida, vida_maxima)

	if vida <= 0:
		esta_muriendo = true
		call_deferred("_morir")

func _morir() -> void:
	get_tree().change_scene_to_file("res://escenas/game_over.tscn")

func clamp_to_limits(limit_pos: Vector2, limit_size: Vector2):

	var player_size: Vector2 = self.animated_sprite_2d.sprite_frames.get_frame_texture("idle_abajo", 0).get_size() * self.scale
	
	global_position.x = clamp(global_position.x, limit_pos.x + (player_size.x / 2) , limit_pos.x + limit_size.x - (player_size.x / 2))
	global_position.y = clamp(global_position.y, limit_pos.y + (player_size.y), limit_pos.y + limit_size.y - (player_size.y / 2))

func crear_duplicado_shader() -> void:

	var duplicado = $AnimatedSprite2D.duplicate(true)

	duplicado.material = $AnimatedSprite2D.material.duplicate(true)

	#configuración del shader
	duplicado.material.set_shader_parameter("opacity", 1.0) #0.7
	duplicado.material.set_shader_parameter("r", 1.0) #0.392
	duplicado.material.set_shader_parameter("g", 1.0) #0.282
	duplicado.material.set_shader_parameter("b", 1.0)#0.235
	duplicado.material.set_shader_parameter("mix_color", 1.0) #0.5

	var posicion_duplicado = global_position

	get_parent().add_child(duplicado)

	duplicado.global_position = posicion_duplicado

	duplicado.z_index = 1

	await get_tree().create_timer(tiempo_vida_duplicado).timeout

	duplicado.queue_free()


func _on_area_2d_body_entered(body: Node2D) -> void:

	$AnimatedSprite2D/espada/espada_sprite.visible = false

func _on_area_2d_body_exited(body: Node2D) -> void:

	$AnimatedSprite2D/espada/espada_sprite.visible = true

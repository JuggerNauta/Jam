extends CharacterBody2D
@onready var animated_sprite_2d: AnimatedSprite2D = $AnimatedSprite2D

#movimiento
var velocidad = 200

#ataque
var actual_vista_dir = "derecha"
var puedo_atacar: bool = false
@export var tiempo_ataque: float = 0.2
@export var tiempo_espada_regresa: float = 0.5
@export var daño_arma: float = 1.0

#animacion movimiento
var ultima_direccion_personaje = "abajo"

#dash
const dash_velocidad: float = 1500
const dash_tiempo: float = 0.12
const dash_costo_recarga: float = 0.2
var puedo_dash: bool = true
var dash_timer: float = 0.0
var dash_dir: Vector2 = Vector2.ZERO
var dash_timer_recarga: float = 0.0
var ultima_direccion: Vector2 = Vector2.ZERO

func _physics_process(_delta):

	_dash_logica(_delta)

	if dash_timer <= 0.0:
		get_input()

	move_and_slide()

func atacar():
	if get_global_mouse_position().y > global_position.y:
		$Sprite2D/espada.show_behind_parent = false
		$Sprite2D.frame = 0
	else:
		$Sprite2D/espada.show_behind_parent = true
		$Sprite2D.frame = 1

	if Input.is_action_pressed("ataque") and puedo_atacar:
		$Sprite2D/sword/AnimationPlayer.speed_scale = $Sprite2D/espada/AnimationPlayer.get_animation("atacar").legth / tiempo_ataque
		$Sprite2D/sword/AnimationPlayer.play("atacar")
		puedo_atacar = false


func spawnear_ataque():
	pass

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	if anim_name == "atacar":
		$Sprite2D/sword/AnimationPlayer.speed_scale = $Sprite2D/espada/AnimationPlayer.get_animation("ataque_regreso").legth / tiempo_espada_regresa
		$Sprite2D/sword/AnimationPlayer.play("ataque_regreso")
	else:
		puedo_atacar = true

#controles movimiento
func get_input():

	var direccion = Vector2.ZERO

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

func actualizar_animacion(stado):
	animated_sprite_2d.play(stado + "_" + ultima_direccion_personaje)


#dash funcion
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

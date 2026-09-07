class_name FilaClientes
extends Node2D

@export_range(1, 10, 1, "or_greater")
var capacidad := 3

@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:px/s")
var velocidad := 120.0

const SEPARACION := 40.0

var _fila: Array = []
var _saliendo: Array = []

@onready var _punto_a: Marker2D = $PuntoA
@onready var _punto_b: Marker2D = $PuntoB
@onready var _clientes: Node2D = $Clientes
@onready var _spawner: SpawnerClientes = $Spawner
@onready var _mostrador: Mostrador = $Mostrador


func _ready() -> void:
	_spawner.cliente_creado.connect(_al_crear_cliente)
	_mostrador.atendido.connect(_al_terminar_atencion)


func _physics_process(delta: float) -> void:
	var avance := velocidad * delta

	for i in _fila.size():
		var llego := _mover_hacia(_fila[i], _puesto(i), avance)
		if i == 0 and llego and not _mostrador.atendiendo:
			var sprites = _fila[i].get_node("Visual") as AnimatedSprite2D
			sprites.play("idle")
			_mostrador.atender()

	for i in range(_saliendo.size() - 1, -1, -1):
		if _mover_hacia(_saliendo[i], _punto_a.global_position, avance):
			_saliendo[i].queue_free()
			_saliendo.remove_at(i)

	_spawner.pausado = _fila.size() >= capacidad


func _mover_hacia(cliente: Node2D, objetivo: Vector2, avance: float) -> bool:
	cliente.global_position = cliente.global_position.move_toward(objetivo, avance)
	return cliente.global_position.is_equal_approx(objetivo)


func _al_crear_cliente(cliente:Node2D) -> void:
	_clientes.add_child(cliente)
	var sprites = cliente.get_node("Visual")
	sprites.play("walking")
	cliente.global_position = _punto_a.global_position
	_fila.append(cliente)


func _al_terminar_atencion() -> void:
	if not _fila.is_empty():
		var cliente = _fila.pop_front()

		var sprite := cliente.get_node("Visual") as AnimatedSprite2D
		sprite.play("walking")

		cliente.scale.x *= -1

		_saliendo.append(cliente)


func _puesto(indice: int) -> Vector2:
	var direccion := (_punto_b.global_position - _punto_a.global_position).normalized()
	if direccion == Vector2.ZERO:
		direccion = Vector2.RIGHT
	return _punto_b.global_position - direccion * indice * SEPARACION

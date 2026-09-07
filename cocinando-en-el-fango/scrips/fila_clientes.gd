class_name FilaClientes
extends Node2D

const BURBUJA := preload("res://escenas/objetos/burbuja_pedido.tscn")

@export_range(1, 10, 1, "or_greater")
var capacidad := 3

@export_range(0.0, 1000.0, 1.0, "or_greater", "suffix:px/s")
var velocidad := 120.0

const SEPARACION := 40.0
const PUNTOS_POR_CLIENTE := 50

var _fila: Array = []
var _saliendo: Array = []

var counter_food_pool: CounterFoodPool
var _score_manager: Node


@onready var _punto_a: Marker2D = $PuntoA
@onready var _punto_b: Marker2D = $PuntoB
@onready var _clientes: Node2D = $Clientes
@onready var _spawner: SpawnerClientes = $Spawner
@onready var _mostrador: Mostrador = $Mostrador


func _ready() -> void:
	add_to_group("filas_clientes")

	counter_food_pool = get_tree().get_first_node_in_group("counter_food") as CounterFoodPool
	_score_manager = get_tree().get_first_node_in_group("score_manager")

	_spawner.cliente_creado.connect(_al_crear_cliente)
	_mostrador.atendido.connect(_al_terminar_atencion)

	if counter_food_pool:
		counter_food_pool.item_servido.connect(_al_item_servido)


func _physics_process(delta: float) -> void:
	var avance := velocidad * delta

	for i in _fila.size():
		var llego := _mover_hacia(
			_fila[i],
			_puesto(i),
			avance
		)

		if i == 0 and llego and not _mostrador.atendiendo:
			var sprites := _fila[i].get_node("Visual") as AnimatedSprite2D

			sprites.play("idle")

			_mostrador.atender()
			_iniciar_pedido(_fila[i])

	for i in range(_saliendo.size() - 1, -1, -1):
		if _mover_hacia(
			_saliendo[i],
			_punto_a.global_position,
			avance
		):
			_saliendo[i].queue_free()
			_saliendo.remove_at(i)

	if _mostrador.atendiendo and not _fila.is_empty():
		_actualizar_tiempo_burbuja(_fila[0])

	_spawner.pausado = _fila.size() >= capacidad


func _mover_hacia(
	cliente: Node2D,
	objetivo: Vector2,
	avance: float
) -> bool:

	cliente.global_position = cliente.global_position.move_toward(
		objetivo,
		avance
	)

	return cliente.global_position.is_equal_approx(objetivo)


func _al_crear_cliente(cliente: Node2D) -> void:
	_clientes.add_child(cliente)

	var sprites := cliente.get_node("Visual") as AnimatedSprite2D

	sprites.play("walking")

	cliente.global_position = _punto_a.global_position

	if counter_food_pool:
		var pedido := counter_food_pool.sortear_pedido()

		cliente.set_meta("pedido", pedido)

		cliente.set_meta("pedido_pendiente", pedido.duplicate())

	cliente.set_meta("satisfecho", false)

	_fila.append(cliente)


func _iniciar_pedido(cliente: Node2D) -> void:
	if not counter_food_pool:
		return

	if not cliente.has_meta("pedido"):
		return

	var pedido: Array[ObjetoData] = cliente.get_meta("pedido")

	var burbuja := BURBUJA.instantiate()

	cliente.add_child(burbuja)

	burbuja.position = Vector2(0, -18)

	burbuja.mostrar(pedido)

	cliente.set_meta("burbuja", burbuja)


func _actualizar_tiempo_burbuja(cliente: Node2D) -> void:
	if not cliente.has_meta("burbuja"):
		return

	var burbuja = cliente.get_meta("burbuja")

	if is_instance_valid(burbuja):
		var restante := _mostrador.duracion - _mostrador._tiempo

		burbuja.actualizar_tiempo(restante)


func obtener_cliente_que_pide(item: ObjetoData) -> Node2D:
	for cliente in _fila:

		if cliente != _fila[0]:
			continue

		if not cliente.has_meta("pedido_pendiente"):
			continue

		var pedido_pendiente: Array[ObjetoData] = cliente.get_meta(
			"pedido_pendiente"
		)

		for objeto in pedido_pendiente:
			if objeto.nombre == item.nombre:
				return cliente

	return null


func _al_item_servido(
	item: ObjetoData,
	cliente: Node2D
) -> void:

	if cliente not in _fila:
		return

	if not cliente.has_meta("pedido_pendiente"):
		return

	var pedido_pendiente: Array[ObjetoData] = cliente.get_meta(
		"pedido_pendiente"
	)

	for i in range(pedido_pendiente.size() - 1, -1, -1):
		if pedido_pendiente[i].nombre == item.nombre:
			pedido_pendiente.remove_at(i)
			break

	cliente.set_meta(
		"pedido_pendiente",
		pedido_pendiente
	)

	if cliente.has_meta("burbuja"):
		var burbuja = cliente.get_meta("burbuja")

		if is_instance_valid(burbuja):
			burbuja.marcar_servido_item(item)

	if pedido_pendiente.is_empty():
		_completar_pedido(cliente)


func _completar_pedido(cliente: Node2D) -> void:
	if cliente not in _fila:
		return

	cliente.set_meta(
		"satisfecho",
		true
	)

	if _score_manager:
		_score_manager.agregar_puntos(
			PUNTOS_POR_CLIENTE
		)

	if cliente == _fila[0]:
		_mostrador.atendiendo = false
		_mostrador.atendido.emit()


func _al_terminar_atencion() -> void:
	if _fila.is_empty():
		return

	var cliente = _fila.pop_front()

	var satisfecho: bool = cliente.get_meta(
		"satisfecho",
		false
	)

	if cliente.has_meta("burbuja"):
		var burbuja = cliente.get_meta("burbuja")

		if is_instance_valid(burbuja):

			if satisfecho:
				burbuja.mostrar_feliz()
			else:
				burbuja.mostrar_enojado()

	var sprite := cliente.get_node("Visual") as AnimatedSprite2D

	sprite.play("walking")

	cliente.scale.x *= -1

	if cliente.has_meta("burbuja"):
		var burbuja_saliente = cliente.get_meta("burbuja")

		if is_instance_valid(burbuja_saliente):
			burbuja_saliente.scale.x *= -1

	_saliendo.append(cliente)


func _puesto(indice: int) -> Vector2:
	var direccion := (
		_punto_b.global_position
		- _punto_a.global_position
	).normalized()

	if direccion == Vector2.ZERO:
		direccion = Vector2.RIGHT

	return (
		_punto_b.global_position
		- direccion * indice * SEPARACION
	)

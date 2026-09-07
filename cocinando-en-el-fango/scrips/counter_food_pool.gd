class_name CounterFoodPool
extends Node

signal item_servido(item: ObjetoData, cliente: Node2D)
signal pedido_completo(cliente: Node2D)

@export var pool_food: Array[ObjetoData] = []

var _player_en_zona := false

@onready var zona_servicio: Area2D = $ZonaServicio


func _ready() -> void:
	add_to_group("counter_food")

	zona_servicio.body_entered.connect(_on_body_entered)
	zona_servicio.body_exited.connect(_on_body_exited)


func _process(_delta: float) -> void:
	if _player_en_zona and Input.is_key_pressed(KEY_E):
		_intentar_servir()


func sortear_pedido() -> Array[ObjetoData]:
	var copia := pool_food.duplicate()
	copia.shuffle()

	var resultado: Array[ObjetoData] = []

	for i in min(1, copia.size()):
		resultado.append(copia[i])

	return resultado


func _on_body_entered(body: Node) -> void:
	if body is Player:
		_player_en_zona = true


func _on_body_exited(body: Node) -> void:
	if body is Player:
		_player_en_zona = false


func obtener_cliente_que_pide(item: ObjetoData) -> Node2D:
	for fila in get_tree().get_nodes_in_group("filas_clientes"):
		var cliente: Node2D = fila.obtener_cliente_que_pide(item)

		if cliente != null:
			return cliente

	return null


func _intentar_servir() -> void:
	for item in pool_food:
		if not Inventario.tiene_objeto_por_nombre(item.nombre):
			continue

		var cliente := obtener_cliente_que_pide(item)

		if cliente == null:
			continue

		if Inventario.eliminar_objeto_por_nombre(item.nombre, 1):
			item_servido.emit(item, cliente)

		return

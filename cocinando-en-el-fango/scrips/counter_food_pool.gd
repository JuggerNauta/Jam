class_name CounterFoodPool
extends Node

signal item_servido(item: ObjetoData)
signal pedido_completo
@export var pool_food : Array[ObjetoData] = []

var pedido_actual : Array[ObjetoData] = []
var _player_en_zona := false
@onready var zona_servicio: Area2D = $ZonaServicio


func _ready() -> void:
	add_to_group("counter_food")
	zona_servicio.body_entered.connect(_on_body_entered)
	zona_servicio.body_exited.connect(_on_body_exited)

func _process(_delta: float) -> void:
	if _player_en_zona:
		_intentar_servir()


func sortear_pedido() -> Array[ObjetoData]:
	var copia := pool_food.duplicate()
	copia.shuffle()
	var resultado : Array[ObjetoData] = []
	for i in min(1, copia.size()):
		resultado.append(copia[i])
	return resultado

func iniciar_pedido(items: Array[ObjetoData]) -> void:
	pedido_actual = items.duplicate()


func _on_body_entered(body: Node) -> void:
	if body is Player:
		_player_en_zona = true
		_intentar_servir()

func _on_body_exited(body: Node) -> void:
	if body is Player:
		_player_en_zona = false


func _intentar_servir() -> void:
	if pedido_actual.is_empty():
		return
	var hubo_cambio := false
	for i in range(pedido_actual.size() - 1, -1, -1):
		var item = pedido_actual[i]
		if Inventario.eliminar_objeto_por_nombre(item.nombre, 1):
			item_servido.emit(item)
			pedido_actual.remove_at(i)
			hubo_cambio = true

	if hubo_cambio and pedido_actual.is_empty():
		pedido_completo.emit()

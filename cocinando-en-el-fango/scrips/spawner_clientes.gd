class_name SpawnerClientes
extends Node

signal cliente_creado(cliente: Node2D)

@export var escenas: Array[PackedScene]
@export_range(0.1, 15.0, 0.1, "or_greater", "suffix:s")
var intervalo_min := 1.0
@export_range(0.1, 15.0, 0.1, "or_greater", "suffix:s")
var intervalo_max := 9.0

var pausado := false

var _tiempo := 0.0
var _intervalo_actual := 0.0


func _ready() -> void:
	_intervalo_actual = randf_range(intervalo_min, intervalo_max)


func _process(delta: float) -> void:
	if pausado or escenas == null or len(escenas)  < 1:
		return

	var escena = escenas[randi_range(0, len(escenas)-1)]
	_tiempo += delta
	if _tiempo >= _intervalo_actual:
		_tiempo = 0.0
		_intervalo_actual = randf_range(intervalo_min, intervalo_max)
		cliente_creado.emit(escena.instantiate())

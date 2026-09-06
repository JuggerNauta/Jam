class_name SpawnerClientes
extends Node

signal cliente_creado(cliente: Node2D)

@export var escenas: Array[PackedScene]
@export_range(0.1, 5.0, 0.1, "or_greater", "suffix:s")
var intervalo := 2.0

var pausado := false

var _tiempo := 0.0


func _process(delta: float) -> void:
	if pausado or escenas == null or len(escenas)  < 1:
		return
		
	var escena = escenas[randi_range(0, len(escenas)-1)]
	_tiempo += delta
	if _tiempo >= intervalo:
		_tiempo = 0.0
		cliente_creado.emit(escena.instantiate())

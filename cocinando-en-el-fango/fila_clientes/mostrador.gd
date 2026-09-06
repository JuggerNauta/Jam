class_name Mostrador
extends Node

signal atendido

@export_range(0.0, 10.0, 0.1, "or_greater", "suffix:s")
var duracion := 2.0

var atendiendo := false

var _tiempo := 0.0


func _process(delta: float) -> void:
	if not atendiendo:
		return
	_tiempo += delta
	if _tiempo >= duracion:
		atendiendo = false
		atendido.emit()


func atender() -> void:
	if not atendiendo:
		atendiendo = true
		_tiempo = 0.0

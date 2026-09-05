extends Node

signal objeto_recogido(indice: int, objeto: ObjetoData)

var slots: Array[ObjetoData] = []

func _ready() -> void:
	slots.resize(6)

func agregar_objeto(objeto: ObjetoData) -> bool:
	var indice := slots.find(null)
	if indice == -1:
		return false
	slots[indice] = objeto
	objeto_recogido.emit(indice, objeto)
	return true

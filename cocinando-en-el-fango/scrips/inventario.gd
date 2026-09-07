extends Node

signal objeto_recogido(indice: int, objeto: ObjetoData)
signal objeto_soltado(indice: int, objeto: ObjetoData)
signal objeto_eliminado(indice: int, objeto: ObjetoData)

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

func tiene_objeto(objeto: ObjetoData) -> bool:
	for slot in slots:
		if slot != null and slot.nombre == objeto.nombre:
			return true

	return false



func soltar_objeto(indice: int) -> void:

	var objeto := slots[indice]

	if objeto == null:

		return

	slots[indice] = null
	objeto_soltado.emit(indice, objeto)


func eliminar_objeto(indice: int) -> void:

	var objeto := slots[indice]

	if objeto == null:

		return

	slots[indice] = null
	objeto_eliminado.emit(indice, objeto)

func eliminar_objeto_por_nombre(nombre: String, count: int = 1) -> bool:
	var remaining = count
	for i in slots.size():
		if remaining < 1:
			return true
		var objeto := slots[i]
		if objeto != null and objeto.nombre == nombre:
			eliminar_objeto(i)
			remaining -= 1
			#return true

	return false

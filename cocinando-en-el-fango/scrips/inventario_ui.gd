extends CanvasLayer

func _ready() -> void:

	Inventario.objeto_recogido.connect(_on_objeto_recogido)
	Inventario.objeto_soltado.connect(_on_objeto_soltado)
	SelectorSlot.cambio.connect(_on_seleccion_cambiada)

	_on_seleccion_cambiada(SelectorSlot.indice)

func _on_objeto_recogido(indice: int, objeto: ObjetoData) -> void:

	var icono := _icono(indice)

	icono.color = objeto.color
	icono.visible = true
	icono.tooltip_text = objeto.nombre

func _on_objeto_soltado(indice: int, _objeto: ObjetoData) -> void:

	_icono(indice).visible = false

func _on_seleccion_cambiada(indice: int) -> void:

	for i in 6:

		$Control/HBoxContainer.get_child(i).modulate = Color.WHITE
	$Control/HBoxContainer.get_child(indice).modulate = Color(1.4, 1.4, 1.4)

func _icono(indice: int) -> ColorRect:

	return $Control/HBoxContainer.get_child(indice).get_node("Icono")

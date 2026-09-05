extends CanvasLayer

func _ready() -> void:
	Inventario.objeto_recogido.connect(_on_objeto_recogido)

func _on_objeto_recogido(indice: int, objeto: ObjetoData) -> void:
	var icono = $Control/HBoxContainer.get_child(indice).get_node("Icono")
	icono.color = objeto.color
	icono.visible = true
	icono.tooltip_text = objeto.nombre

extends Node2D

@onready var _icono : TextureRect = $Fondo/Fila/Icono
@onready var _texto : Label = $Fondo/Fila/Texto
@onready var _tiempo : Label = $Tiempo
# esto si lo deje fino fino


func mostrar(items: Array[ObjetoData]) -> void:
	if items.is_empty():
		return
	var item := items[0]
	_icono.texture = item.sprite
	_icono.visible = true
	_icono.modulate = Color(1, 1, 1, 1)
	_texto.text = item.nombre

func marcar_servido_item(_item: ObjetoData) -> void:
	_icono.modulate = Color(1, 1, 1, 0.2)
	_texto.text = "listo"


func actualizar_tiempo(restante: float) -> void:
	_tiempo.text = "%.1fs" % max(restante, 0.0)


func mostrar_enojado() -> void:
	_icono.visible = false
	_texto.text = "me voy enojado"
	_tiempo.text = ""

func mostrar_feliz() -> void:
	_icono.visible = false
	_texto.text = "♥"
	_tiempo.text = ""

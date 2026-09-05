extends Area2D

@export var color := Color.WHITE
@export var nombre := "objeto"

func _ready() -> void:
	$Polygon2D.color = color
	body_entered.connect(_on_body_entered)

func _on_body_entered(body: Node) -> void:
	if not body.is_in_group("jugador"):
		return

	var datos := ObjetoData.new(color, nombre)
	if not Inventario.agregar_objeto(datos):
		return

	queue_free()

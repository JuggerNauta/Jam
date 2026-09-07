extends CanvasLayer

const CORAZON_LLENO = preload("res://assets/corazones/corazon.png")
const CORAZON_MEDIO = preload("res://assets/corazones/corazon-sheet.png")

@onready var corazones: Array[TextureRect] = [
	$Control/HBoxContainer/Corazon1,
	$Control/HBoxContainer/Corazon2,
	$Control/HBoxContainer/Corazon3,
	$Control/HBoxContainer/Corazon4,
	$Control/HBoxContainer/Corazon5,
]

func _ready() -> void:
	var jugador := get_tree().get_first_node_in_group("jugador")

	jugador.vida_cambiada.connect(_actualizar)
	_actualizar(jugador.vida, jugador.vida_maxima)

func _actualizar(actual: float, maxima: float) -> void:
	var vida_por_corazon := maxima / corazones.size()

	for i in corazones.size():
		var corazon := corazones[i]
		var vida_restante := actual - vida_por_corazon * i

		if vida_restante >= vida_por_corazon:
			corazon.texture = CORAZON_LLENO
			corazon.modulate = Color.WHITE
		elif vida_restante > 0:
			corazon.texture = CORAZON_MEDIO
			corazon.modulate = Color.WHITE
		else:
			corazon.texture = CORAZON_LLENO
			corazon.modulate = Color(0.25, 0.25, 0.25)

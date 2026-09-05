extends Resource
class_name ObjetoData

var color: Color
var nombre: String

func _init(p_color := Color.WHITE, p_nombre := "objeto") -> void:
	color = p_color
	nombre = p_nombre

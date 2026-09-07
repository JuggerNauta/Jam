class_name ObjetoData
extends Resource

@export var color: Color = Color.RED
@export var nombre: String = "PONER_NOMBRE"
@export var sprite : Texture2D = AtlasTexture.new()

func _init(p_color := Color.WHITE, p_nombre := "objeto") -> void:
	color = p_color
	nombre = p_nombre

func _to_string() -> String:
	return nombre

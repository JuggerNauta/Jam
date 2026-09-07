extends CanvasLayer

@export var jugador: Player
@export var mapa_minimapa: TileMapLayer

@onready var sub_viewport: SubViewport = $SubViewportContainer/SubViewport
@onready var camera: Camera2D = $SubViewportContainer/SubViewport/Camera2D
@onready var minimapa_jugador: Sprite2D = $SubViewportContainer/SubViewport/minimapa_jugador


func _ready() -> void:
	var mapa = mapa_minimapa.duplicate()
	mapa.position = Vector2.ZERO
	sub_viewport.add_child(mapa)

func _process(_delta: float) -> void:
	minimapa_jugador.position = jugador.global_position
	camera.position = jugador.global_position

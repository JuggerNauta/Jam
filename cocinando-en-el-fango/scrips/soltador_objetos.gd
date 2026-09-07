extends Node

const OBJETO_RECOGIBLE := preload("res://escenas/objetos/item_drop.tscn")

func _ready() -> void:
	Inventario.objeto_soltado.connect(_on_objeto_soltado)

func _on_objeto_soltado(_indice: int, objeto: ObjetoData) -> void:
	var jugador := get_tree().get_first_node_in_group("jugador")
	var instancia := OBJETO_RECOGIBLE.instantiate()
	var sprite = instancia.get_node("ItemSprite") as Sprite2D
	
	sprite.texture = objeto.sprite
	instancia.stack = ItemStack.new(objeto, 1)
	instancia.global_position = jugador.global_position + Vector2(0, 10)
	get_tree().current_scene.add_child(instancia)

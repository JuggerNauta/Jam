extends Node

var EMPTY : ObjetoData = ObjetoData.new()
const FLY_MEAT : ObjetoData = preload("res://resources/items/ingredients/fly_meat.tres")
const CUIJA_MEAT : ObjetoData = preload("res://resources/items/ingredients/cuija_meat.tres")
const CRAB_MEAT : ObjetoData = preload("res://resources/items/ingredients/crab_meat.tres")

var all_items = [
	EMPTY,
	FLY_MEAT,
	CUIJA_MEAT,
	CRAB_MEAT,
	#STICK,
	#ROCK
]

var item_registry := {}


func _ready() -> void:
	_register_items()
	Ingredientes.EMPTY.nombre = "VACIO"


func _register_items() -> void:
	for item in all_items:
		item_registry[item.nombre] = item


func get_item(item_name: String) -> ObjetoData:
	return item_registry.get(item_name)

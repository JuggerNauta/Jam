class_name CraftingRecipe
extends Resource


@export var ingredients : Array[CraftingIngredient]

@export var output : CraftingIngredient


func craft(inventory: Inventario) -> void:
	
	for ingredient in ingredients:
		inventory.eliminar_objeto_por_nombre(ingredient.item.nombre)
	
	inventory.agregar_objeto(output.item)



func can_craft(inventory: Inventario) -> bool:
	var valid = true
	
	for ingredient in ingredients:
		if !inventory.tiene_objeto(ingredient.item):
			valid = false
	
	return valid

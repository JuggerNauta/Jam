class_name CraftingRegistry


static var recipes : Array[CraftingRecipe]


static func _static_init() -> void:
	load_resources("res://resources/recipes")


static func load_resources(path: String) -> void:
	if !path.ends_with("/"):
		path += "/"
	
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			recipes.append(load(path + file_name))
			file_name = dir.get_next()


static func get_craftable(inventory: Inventario) -> Array[CraftingRecipe]:
	var valid_recipes : Array[CraftingRecipe]
	
	for r in recipes:
		if r.can_craft(inventory):
			valid_recipes.append(r)
	
	return valid_recipes

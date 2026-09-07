class_name LootTable
extends Resource


## Mapped by item, weight
@export var item_rolls : Array[ItemRoll]

@export var roll_times := 1

var rng := RandomNumberGenerator.new()


func roll_loot() -> Array[ItemStack]:
	var items : Array[ItemStack]
	var weights : Array = item_rolls.map(func(roll: ItemRoll): return roll.weight)
	
	for i in roll_times:
		var index := rng.rand_weighted(weights)
		var roll : ItemRoll = item_rolls[index]
		if roll.item:
			items.append(ItemStack.new(roll.item, roll.count))
	
	return items

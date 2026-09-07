class_name ItemStack

# Yeah I'm using ItemStacks
# My experience modding minecraft is showing

signal item_changed(item: ObjetoData)

static var max_count := 100

var item : ObjetoData:
	set(val):
		item = val
		item_changed.emit(val)

var count : int


func _init(item: ObjetoData, count: int = 0):
	self.item = item
	self.count = count


func is_empty() -> bool:
	return item == Ingredientes.EMPTY


func _to_string() -> String:
	return "ObjetoData: " + str(item) + " - " + str(count)

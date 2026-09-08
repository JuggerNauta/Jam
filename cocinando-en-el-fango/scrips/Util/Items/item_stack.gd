class_name ItemStack

signal item_changed(item: ObjetoData)

static var max_count := 100

var _item: ObjetoData

var item: ObjetoData:
	get:
		return _item
	set(val):
		_item = val
		item_changed.emit(val)

var count: int


func _init(nuevo_item: ObjetoData, nueva_cantidad: int = 0):
	self.item = nuevo_item
	self.count = nueva_cantidad


func is_empty() -> bool:
	return item == Ingredientes.EMPTY


func _to_string() -> String:
	return "ObjetoData: " + str(item) + " - " + str(count)

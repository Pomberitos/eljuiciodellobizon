class_name Inventory extends Resource

@export var item_slots: Array[InventorySlot]

signal update

func insert(item: InventoryItem)-> void:
	var _slots = item_slots.filter(func(slot): return slot.item == item)
	if !_slots.is_empty() and _slots[0].amount < item.max_stack and !item.is_key_item:
		_slots[0].amount += 1
	elif !_slots.is_empty() and item.is_key_item:
		pass
	else:
		var _empty_slots = item_slots.filter(func(slot): return slot.item == null)
		if !_empty_slots.is_empty():
			_empty_slots[0].item = item
			_empty_slots[0].amount = 1
	update.emit()

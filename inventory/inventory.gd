class_name Inventory extends Resource

@export var item_slots: Array[InventorySlot]

signal update

# Function to insert an item into the inventory
func insert(item: InventoryItem) -> void:
	# Find slots that already contain the item
	var _slots = item_slots.filter(func(slot): return slot.item == item)
	
	# If the item is already present and can stack, increment the amount
	if !_slots.is_empty() and _slots[0].amount < item.max_stack and !item.is_key_item:
		_slots[0].amount += 1
	
	# If the item is a key item and already present, do nothing
	elif !_slots.is_empty() and item.is_key_item:
		pass
	
	# If the item is not present in any slot
	else:
		# Find an empty slot to place the new item
		var _empty_slots = item_slots.filter(func(slot): return slot.item == null)
		
		# If there is an empty slot, place the item there and set the amount to 1
		if !_empty_slots.is_empty():
			_empty_slots[0].item = item
			_empty_slots[0].amount = 1
	
	# Emit the update signal after inserting the item
	update.emit()

# Function to remove an item from the inventory, either by consuming or discarding
func remove(item: InventoryItem, amount: int = 1) -> bool:
	# Find the slots that contain the item
	var _slots = item_slots.filter(func(slot): return slot.item == item)
	if _slots.is_empty():
		return false  # Item not found in the inventory

	var _slot = _slots[0]
	if _slot.amount < amount:
		return false  # Not enough items to remove

	_slot.amount -= amount
	if _slot.amount <= 0:
		_slot.item = null  # Remove the item if the amount is zero or less

	update.emit()
	return true  # Successfully removed the item

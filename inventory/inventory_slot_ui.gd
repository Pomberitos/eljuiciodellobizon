class_name InventorySlotUI extends Panel

@export var item_display: Sprite2D
@export var amount_label: Label

func update(item_slot: InventorySlot) -> void:
	if !item_slot.item:
		item_display.visible = false
		amount_label.visible = false
	else:
		item_display.visible = true
		item_display.texture = item_slot.item.texture
		amount_label.visible = true
		amount_label.text = str(item_slot.amount)

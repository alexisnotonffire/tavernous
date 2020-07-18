extends Reference

class_name Purchasable

var name

var unlocked
var count: float = 0
var cost: float

var overhead
var overhead_frequency = 1

var revenue
var revenue_frequency = 1

# cost factor for additional item
func get_cost():
	return cost * pow(10, count)

func get_overhead(tick):
	if (tick % overhead_frequency) == 0:
		return overhead * count

func get_revenue(tick):
	if (tick % revenue_frequency) == 0:
		return revenue * count

func on_purchase():
	pass

extends Purchasable

class_name Stool

var retention_factor: float
var retention_threshold = 0.5
var seated: Array = []

func _init(name, cost, overhead, retention_factor):
	self.name = name
	self.cost = cost 
	self.overhead = overhead
	self.retention_factor = retention_factor
	
	

func get_available_seats():
	return count - seated.size()

func update_seated_patrons():
	var leaving_patrons = []
	for patron in range(seated.size()):
		if seated[patron].get_retention() * retention_factor \
			< retention_threshold:
			leaving_patrons.append(patron)
	
	leaving_patrons.invert()
	for patron in leaving_patrons:
		seated.remove(patron)

func add_stool(num):
	count += num

func add_patron(patron):
	seated.append(patron)

func get_cost():
	return cost * pow(10, (count / 100))

func get_overhead(_tick=1):#
	return overhead * count

func get_revenue(_tick=1):
	var revenue = 0
	var price = 10
	var drinks_bought = 0
	for patron in seated:
		revenue += patron.buy_drink(price)
		drinks_bought += min(revenue, 1)
		
	return {
		"cash": revenue,
		"drinks_bought": drinks_bought
	}

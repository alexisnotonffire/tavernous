extends Reference

class_name Patron

var max_cash: int
var available_cash: int

var patron_type: String

var max_drinks: int
var available_drinks: int

var purchase_threshold: float
var retention_factor: float

func _init(patron, cash, drinks, retention=0.5, purchase=0.5):
	patron_type = patron
	
	randomize()
	max_cash = int(max(rand_range(cash - cash * 0.8, cash), 1))
	available_cash = max_cash
	
	randomize()
	max_drinks = int(max(rand_range(drinks - drinks * 0.8, drinks), 1))
	available_drinks = max_drinks
	
	retention_factor = retention
	purchase_threshold = purchase

func get_retention() -> float:
	var drink_retention = float(available_drinks) / max_drinks
	var cash_retention = float(available_cash) / max_cash
	return retention_factor * drink_retention * cash_retention

func buy_drink(cash):
	randomize()
	if cash <= available_cash && randf() > purchase_threshold:
		available_cash -= cash
		available_drinks -= 1
		return cash
	
	return 0

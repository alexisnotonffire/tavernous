extends Reference

class_name PatronFactory

var patrons = {
	"basic": patron(0.7, 3, 150, 0.5, 0.4),
	"thirsty": patron(0.2, 8, 200, 0.5, 0.3),
	"cheap": patron(0.1, 2, 50, 0.5, 0.6)
}

func patron(weight, max_drinks, max_cash, retention_factor, purchase_factor):
	return {
		"weight": weight,
		"max_drinks": max_drinks, 
		"max_cash": max_cash, 
		"retention_factor": retention_factor,
		"purchase_factor": purchase_factor
	}

func create_patron(name):
	if name == "auto":
		randomize()
		var rng = randf()
		for key in patrons.keys():
			rng -= patrons[key]["weight"]
			if rng < 0:
				name = key
				break
			
	return Patron.new(
		name,
		patrons[name]["max_cash"],
		patrons[name]["max_drinks"],
		patrons[name]["retention_factor"],
		patrons[name]["purchase_factor"]
	)

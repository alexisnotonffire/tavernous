extends Reference

class_name StoolFactory

var stools = {
	'basic': stool(5, 1, 0.5),
	'comfy': stool(10, 5, 0.8),
}

func stool(cost, overhead, retention_factor):
	return {
		"cost": cost,
		"overhead": overhead,
		"retention_factor": retention_factor
	}

func create_stool(name):
	return Stool.new(
		name, 
		stools[name]["cost"],
		stools[name]["overhead"],
		stools[name]["retention_factor"]
		)

extends PanelContainer

var label: String 
var value: float

func create_stat_panel(l: String, v: float):
	label = l
	$Organisation/NamePanel/StatName.text = label
	set_value(v)
	

func set_value(v: float):
	value = v
	$Organisation/StatValue.text = "%.f" % value

func get_value() -> float:
	return value

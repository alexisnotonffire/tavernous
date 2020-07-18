extends PanelContainer

const i_types = {
	"stool": {
		"factory": StoolFactory, 
		"class": Stool
	}
}

const const_label = "Cost: %*.f"
const overhead_label = "Overhead: %*.f"
const count_label = "Cost: %*.f"

var item

func get_button():
	return $VBoxContainer/MarginContainer/HBoxContainer/TextureButton
	

func update_labels():
	$VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Cost.text = const_label % [
		30 - len(const_label), 
		item.get_cost()
		]
	$VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Overhead.text = overhead_label % [
		30 - len(overhead_label), 
		item.get_overhead()
		]
	$VBoxContainer/MarginContainer/HBoxContainer/VBoxContainer/Count.text = count_label % [
		30 - len(count_label), 
		item.count
		]
		

func create_item(sprite, label, i_type, i_name):
	$VBoxContainer/TitlePanel/Title.add_text(label)
	$VBoxContainer/MarginContainer/HBoxContainer/TextureButton.texture_normal = load(sprite)
	item = i_types[i_type]["factory"].new().create_stool(i_name)
	
	update_labels()
	

func _process(_delta):
	update_labels()
	

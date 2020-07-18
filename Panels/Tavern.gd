extends VBoxContainer

const item = preload("res://Items/Item.tscn")
const stat_panel = preload("res://Panels/StatPanel.tscn")

const patron_name: String = "%s_patron"
const stat_panel_name: String = "stat_panel_%s"
const seating_icon_path: String = "res://Items/Seating/Icons/%s.png"
const stool_name: String = "buy_stool_%s_panel"

var tick: int = 1
var timer
var bundle_size: int = 1
var tick_revenue: Array

var cash: float = 200 
var stools: Dictionary = {}
var rent: float = 10
var overheads: float = 0
var bankrupt: bool = false

var drink_price: float = 10
var drinks_sold: int = 0

var patrons:Dictionary = {"total": 0}
var capacity = 0

var stat_panels: Dictionary = {
	"cash": 0 as float,
	"revenue": 0 as float,
	"stools": 0 as float,
	"patrons": 0 as float
}

func array_average(arr) -> float:
	var arr_count = 0
	var arr_total = 0
	for a in arr:
		arr_total += a
		arr_count += 1
	
	if arr_count == 0:
		return 0 as float
		
	return arr_total / arr_count
		

func update_patrons():
	var patron_update = {"total": 0}
	for key in stools.keys():
		for patron in stools[key].seated:
			patron_update["total"] += 1
			if not patron_update.has(patron.patron_type):
				patron_update[patron.patron_type] = 0
				
			patron_update[patron.patron_type] += 1
			
	return patron_update
	

func buy_stools(name, num):
	if not stools.has(name):
		stools[name] = StoolFactory.new().create_stool(name)
	for _i in range(num):
		if cash >= stools[name].cost:
			stools[name].add_stool(1)
			cash -= stools[name].get_cost()
			
	stat_panels["cash"] = cash

func deduct_overheads():
	var tick_overheads = rent
	
	for stool in stools.values():
		tick_overheads += stool.get_overhead()
	
	overheads = tick_overheads
	cash -= overheads
	if cash <= 0:
		bankrupt = true
		
	stat_panels["cash"] = cash
	stat_panels["revenue"] = array_average(tick_revenue) - overheads - rent
	

func patron_movement():
	capacity = 0
	for stool in stools.values():
		stool.update_seated_patrons()
		
		var spare_stools = stool.get_available_seats()
		if spare_stools > 0 and randf() > 0.1:
			randomize()
			for _p in range(int(rand_range(1, spare_stools))):
				stool.add_patron(PatronFactory.new().create_patron('auto'))
				
		capacity += stool.count
		
	patrons = update_patrons()
	
	stat_panels["stools"] = capacity
	stat_panels["patrons"] = patrons["total"]
	

func patron_rounds():
	var round_revenue: float = 0
	for stool in stools.values():
		var results = stool.get_revenue()
		round_revenue += results["cash"]
		drinks_sold += results["drinks_bought"]
		
	if len(tick_revenue) >= 5:
		tick_revenue.pop_front()
	tick_revenue.push_back(round_revenue)
	cash += round_revenue
		
	stat_panels["cash"] = cash
	stat_panels["revenue"] = array_average(tick_revenue) - overheads - rent

func _ready():
	for key in StoolFactory.new().stools.keys():
		var button = item.instance()
		button.name = stool_name % key
		button.create_item(seating_icon_path % key, key, "stool", key)
		button.get_button().connect(
			"pressed", self, "buy_stools", [key, bundle_size]
			)
		$TavernPanel/ShopPanel.add_child(button, true)
		stools[key] = button.item

	var _m = $Timer.connect("timeout", self, "patron_movement") 
	var _r = $Timer.connect("timeout", self, "patron_rounds") 
	var _o = $Timer.connect("timeout", self, "deduct_overheads") 
	$Timer.start(tick)
	
	stools['basic'].add_stool(5)
	
	create_stats()
	
func create_stats():
	for key in stat_panels.keys():
		var panel = stat_panel.instance()
		panel.name = stat_panel_name % key
		panel.create_stat_panel(key, stat_panels[key])
		$StatPanel/TavernStats.add_child(panel, true)

func _process(_delta):
	for key in stat_panels.keys():
		$StatPanel/TavernStats.get_node(stat_panel_name % key).set_value(stat_panels[key])
	
	if bankrupt:
		$Timer.stop()
		$TavernPanel/BankruptPanel.visible = true
		$TavernPanel/ShopPanel.visible = false
		

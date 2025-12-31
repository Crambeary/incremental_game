extends Node

@onready var l_total_fries: Label = %l_total_fries
@onready var l_fries: Label = %l_fries
@onready var per_second: Label = %per_second

@onready var b_fry: Button = %b_fry
@onready var l_employees: Label = %l_employees
@onready var b_employee: Button = %b_employee
@onready var employee_container: VBoxContainer = %employee_container

@onready var b_crate: Button = %b_crate
@onready var l_crates: Label = %l_crates
@onready var l_potatoes: Label = %l_potatoes
@onready var potatos_per_second: Label = %potatos_per_second
@onready var b_harvest: Button = %b_harvest
@onready var l_harvest_employees: Label = %l_harvest_employees
@onready var b_harvesters: Button = %b_harvesters
@onready var p_delivery: ProgressBar = %p_delivery


@onready var l_dollars: Label = %l_dollars
@onready var haul_per_second: Label = %haul_per_second
@onready var b_haul: Button = %b_haul
@onready var l_fries_per_haul: Label = %l_fries_per_haul
@onready var b_hire_trucker: Button = %b_hire_trucker
@onready var l_truckers: Label = %l_truckers
@onready var p_truck_haul: ProgressBar = %p_truck_haul


@onready var tick_timer: Timer = $Tick

var frys_shown: float
var potatoes_shown: float
var dollars_shown: float
var truckers_shown: float
var current_truck_interval: int = 0
var delivery_in_progress: bool = false
var delivery_time: int = 0
var potatoes_in_delivery = 0


func _ready() -> void:
	b_fry.connect("button_down", fry_time)
	b_employee.connect("button_down", hire_employee)
	employee_container.visible = false
	l_total_fries.text = str(State.total_fries) \
		+ " Fries for the Fry Lord"
	
	b_harvest.connect("button_down", harvest_time)
	b_harvesters.connect("button_down", hire_harvester)
	l_crates.text = str(State.potato_crates) + (\
		" Crate" if State.potato_crates == 1 else " Crates")
	b_crate.connect("button_down", buy_crate)
	
	b_haul.connect("button_down", haul_time)
	b_hire_trucker.connect("button_down", hire_trucker)
	
	State.TICK_RATE = tick_timer.wait_time
	tick_timer.start(State.TICK_RATE)
	tick_timer.connect("timeout", tick)
	p_delivery.max_value = State.truck_interval

func _process(delta: float) -> void:
	frys_shown = lerp(frys_shown, State.current_fries, 0.06)
	l_total_fries.text = str(State.total_fries) \
		+ " Fries for the Fry Lord"
	l_fries.text = str(int(roundf(frys_shown)), " Fries")
	if State.current_fries >= State.hire_cost:
		State.unlock_hire = true
	if State.unlock_hire:
		employee_container.visible = true
	per_second.text = str(roundf(State.current_employees * 2), "/s")
	

	potatoes_shown = lerp(potatoes_shown, State.current_potatoes, 0.06)
	l_potatoes.text = str(int(roundf(potatoes_shown)), \
		(" Potato" if potatoes_shown == 1 else " Potatoes"))
	potatos_per_second.text = str(roundf(State.current_harvesters * 2), "/s")

	b_harvest.disabled = true if delivery_in_progress else false
	l_harvest_employees.text = str("Harvesters: ", State.current_harvesters)
	p_delivery.value = delivery_time
	p_delivery.max_value = State.potato_delivery_time
	l_crates.text = str(State.potato_crates) + (\
		" Crate" if State.potato_crates == 1 else " Crates")

	dollars_shown = lerp(dollars_shown, State.current_dollars, 0.06)
	l_dollars.text = str(State.CURRENCY_CHAR, int(roundf(dollars_shown)))
	
	truckers_shown = lerp(truckers_shown, State.current_trucks, 0.06)
	l_truckers.text = str(int(roundf(truckers_shown)), " Trucks")
	l_fries_per_haul.text = str(int(State.fries_per_truck * State.current_trucks), " Fries per Haul")
	
	haul_per_second.text = str(State.CURRENCY_CHAR, int(State.fries_per_truck * State.current_trucks), "/s")
	p_truck_haul.value = current_truck_interval
	p_truck_haul.max_value = State.truck_interval
	update_ui()

func fry_time() -> void:
	#State.current_fries += 10
	pass


func hire_employee() -> void:
	# auto-click
	if State.current_dollars >= State.hire_cost:
		State.current_dollars -= State.hire_cost
		State.current_employees += 1
		State.hire_cost = roundi(State.hire_cost * 1.1)

func employee_tick() -> void:
	if State.current_employees > 0 and State.current_potatoes > 0:
		var potatoes_to_process = State.current_employees \
			if State.current_potatoes >= State.current_employees \
			else State.current_potatoes
		State.current_potatoes -= potatoes_to_process
		State.current_fries += (potatoes_to_process * State.fries_per_potato)
		
	if delivery_in_progress and delivery_time < State.potato_delivery_time:
		delivery_time += 1
	elif delivery_time >= State.potato_delivery_time:
		State.current_potatoes += potatoes_in_delivery
		potatoes_in_delivery = 0
		delivery_time = 0
		delivery_in_progress = false
		
		
	if current_truck_interval >= State.potato_delivery_time:
		State.current_dollars += (
			(State.current_fries 
			* State.fries_per_truck) 
			* State.dollars_per_fry)
		var fries_in_haul = (State.fries_per_truck * State.current_trucks)
		var fries_to_ship = fries_in_haul \
			if State.current_fries >= fries_in_haul \
			else State.current_fries
		State.current_fries -= fries_to_ship
		State.total_fries += fries_to_ship
		current_truck_interval = 0
	else:
		current_truck_interval += 1


func tick() -> void:
	employee_tick()

func harvest_time() -> void:
	if State.current_dollars >= (State.potato_delivery_cost * State.potato_crates) \
		and not delivery_in_progress:		
		State.current_dollars -= State.potato_delivery_cost \
			* State.potato_crates
		potatoes_in_delivery = State.potato_delivery_amount \
			* State.potato_crates
		delivery_in_progress = true
	
func buy_crate() -> void:
	if State.current_dollars >= State.potato_crates_cost:
		State.potato_crates += 1
		State.current_dollars -= State.potato_crates_cost
		State.potato_crates_cost = roundi(State.potato_crates_cost * 1.1)
	
func hire_harvester() -> void:
	pass
		
func haul_time() -> void:
	pass

func hire_trucker() -> void:
	if State.current_dollars >= State.truck_cost:
		State.current_dollars -= State.truck_cost
		State.current_trucks += 1
		State.truck_cost = roundi(State.truck_cost * 1.1)

func update_ui() -> void:
	b_crate.text = str("Buy Crate (", State.CURRENCY_CHAR, roundi(State.potato_crates_cost), ")")
	b_employee.text = str("Hire(", State.CURRENCY_CHAR, State.hire_cost, ")")
	l_employees.text = str("Friers: ", State.current_employees)
	b_hire_trucker.text = str("Hire(", State.CURRENCY_CHAR, State.truck_cost, ")")
	b_harvest.text = str("Order(", State.CURRENCY_CHAR, \
		State.potato_delivery_cost * State.potato_crates, ")")

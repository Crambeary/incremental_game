extends Node

@onready var l_fries: Label = %l_fries
@onready var per_second: Label = %per_second

@onready var b_fry: Button = %b_fry
@onready var l_employees: Label = %l_employees
@onready var b_employee: Button = %b_employee
@onready var employee_container: VBoxContainer = %employee_container

@onready var tick_timer: Timer = $Tick

# TODO: Move data into a State autoload script, much like the 
# godot-reactive-ui example
# TODO: Add a new state of items, maybe harvesting into a basket, 
# or shipping via trucks
#var current_fries: float = 0
#var unlock_hire := true
#var TICK_RATE # init value in _ready
#var current_employees := 3
#var hire_cost: int = 100
var frys_shown: float

func _ready() -> void:
	b_fry.connect("button_down", fry_time)
	b_employee.connect("button_down", hire_employee)
	employee_container.visible = false
	State.TICK_RATE = tick_timer.wait_time
	tick_timer.start(State.TICK_RATE)
	tick_timer.connect("timeout", tick)

func _process(delta: float) -> void:
	frys_shown = lerp(frys_shown, State.current_fries, 0.06)
	l_fries.text = str(int(roundf(frys_shown)), " Fries")
	if State.current_fries >= State.hire_cost:
		State.unlock_hire = true
	if State.unlock_hire:
		employee_container.visible = true
	per_second.text = str(roundf(State.current_employees * 2), "/s")
	b_employee.text = str("Hire(", State.hire_cost, ")")
	l_employees.text = str("Employees: ", State.current_employees)

func fry_time() -> void:
	State.current_fries += 10

func hire_employee() -> void:
	# auto-click
	if State.current_fries >= State.hire_cost:
		State.current_fries -= State.hire_cost
		State.current_employees += 1
		State.hire_cost = roundi(State.hire_cost * 1.1)

func employee_tick() -> void:
	if State.current_employees > 0:
		State.current_fries += (State.current_employees * 2)

func tick() -> void:
	employee_tick()

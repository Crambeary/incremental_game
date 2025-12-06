extends Node

@onready var l_fries: Label = %l_fries
@onready var per_second: Label = %per_second

@onready var b_fry: Button = %b_fry
@onready var l_employees: Label = %l_employees
@onready var b_employee: Button = %b_employee
@onready var employee_container: VBoxContainer = %employee_container

@onready var tick_timer: Timer = $Tick

var current_fries: float = 0
var unlock_hire := true
var TICK_RATE # init value in _ready
var current_employees := 3
var hire_cost: int = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	b_fry.connect("button_down", fry_time)
	b_employee.connect("button_down", hire_employee)
	employee_container.visible = false
	TICK_RATE = tick_timer.wait_time
	tick_timer.start(TICK_RATE)
	tick_timer.connect("timeout", tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	l_fries.text = str(int(roundf(current_fries)), " Fries")
	if current_fries >= hire_cost:
		unlock_hire = true
	if unlock_hire:
		employee_container.visible = true
	per_second.text = str(roundf(current_employees * 2), "/s")
	b_employee.text = str("Hire(", hire_cost, ")")
	l_employees.text = str("Employees: ", current_employees)
	


func fry_time() -> void:
	current_fries += 1
	
func hire_employee() -> void:
	# auto-click
	if current_fries >= hire_cost:
		current_fries -= hire_cost
		current_employees += 1
		hire_cost = roundi(hire_cost * 1.1)

	

func employee_tick() -> void:
	if current_employees > 0:
		current_fries += (current_employees * 2)


func tick() -> void:
	employee_tick()
	

extends Node

@onready var cookies: Label = $ColorRect/HBoxContainer/VBoxContainer/HBoxContainer/Cookies
@onready var l_cookie: Label = $ColorRect/HBoxContainer/VBoxContainer/HBoxContainer/l_cookie
@onready var cps: Label = $ColorRect/HBoxContainer/VBoxContainer/CPS
@onready var bake: Button = $ColorRect/HBoxContainer/VBoxContainer/Bake
@onready var tick_timer: Timer = $Tick

@onready var employee_container: VBoxContainer = $ColorRect/HBoxContainer/EmployeeContainer
@onready var l_employees: Label = $ColorRect/HBoxContainer/EmployeeContainer/l_employees
@onready var hire: Button = $ColorRect/HBoxContainer/EmployeeContainer/Hire
@onready var d_emp: Label = $ColorRect/HBoxContainer/EmployeeContainer/d_emp


var current_cookies: float = 0
var unlock_hire := false
var TICK_RATE # init value in _ready
var current_employees := 1
var hire_cost = 100

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bake.connect("button_down", bake_cookie)
	hire.connect("button_down", hire_employee)
	employee_container.visible = false
	TICK_RATE = tick_timer.wait_time
	tick_timer.start(TICK_RATE)
	tick_timer.connect("timeout", tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cookies.text = str(int(roundf(current_cookies)))
	if current_cookies >= 10:
		unlock_hire = true
	if unlock_hire:
		employee_container.visible = true
	cps.text = str(roundf(current_employees * 2), "/s")
	hire.text = str("Hire(", hire_cost, ")")
	l_employees.text = str("Employees: ", current_employees)
	


func bake_cookie() -> void:
	current_cookies += 1
	
func hire_employee() -> void:
	# auto-click
	if current_cookies >= hire_cost:
		current_cookies -= hire_cost
		current_employees += 1
		hire_cost = roundf(hire_cost * 1.1)

	

func employee_tick() -> void:
	if current_employees > 0:
		current_cookies += (current_employees * 2)


func tick() -> void:
	employee_tick()
	

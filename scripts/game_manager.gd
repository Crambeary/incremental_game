extends Node

@onready var cookies: Label = $ColorRect/VBoxContainer/Cookies
@onready var l_cookie: Label = $ColorRect/VBoxContainer/l_cookie
@onready var bake: Button = $ColorRect/VBoxContainer/Bake
@onready var hire: Button = $ColorRect/VBoxContainer/Hire
@onready var tick_timer: Timer = $Tick


var current_cookies: float = 0
var unlock_hire := false
var TICK_RATE := 0.1
var current_employees := 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bake.connect("button_down", bake_cookie)
	hire.connect("button_down", hire_employee)
	tick_timer.start(TICK_RATE)
	tick_timer.connect("timeout", tick)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cookies.text = str(current_cookies)
	if current_cookies >= 10:
		unlock_hire = true
	if unlock_hire:
		hire.visible = true
		


func bake_cookie() -> void:
	current_cookies += 1
	
func hire_employee() -> void:
	# auto-click
	if current_cookies >= 10:
		current_cookies -= 10
		current_employees += 1
	

func employee_tick() -> void:
	if current_employees > 0:
		current_cookies += (current_employees * 0.1)


func tick() -> void:
	employee_tick()
	

extends Node

var TICK_RATE # init value in _ready
var CURRENCY_CHAR = "$"

var total_fries: float = 0
var current_fries: float = 0
var unlock_hire := true
var current_employees: float = 1
var hire_cost: int = 100
var fries_per_potato: int = 8
var potatoes_per_employee = 1

var current_potatoes: float = 10
var potato_crates: int = 1
var potato_crates_cost: float = 15
var unlock_potato_hire := true
var current_harvesters := 1
var harvester_cost: int = 100
var potato_delivery_time: int = 10
var potato_delivery_cost: int = 20
var potato_delivery_amount: int = 10

var current_dollars: float = 100
var current_trucks: float = 1
var fries_per_truck: int = 100
var dollars_per_fry: float = 0.02
var truck_cost: int = 100
var truck_interval: int = 15

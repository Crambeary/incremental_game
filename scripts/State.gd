extends Node

var TICK_RATE # init value in _ready

var current_fries: float = 0
var unlock_hire := true
var current_employees := 1
var hire_cost: int = 100
var fries_per_potato: int = 8

var current_potatoes: float = 0
var unlock_potato_hire := true
var current_harvesters := 1
var harvester_cost: int = 100

var current_dollars: float = 0
var current_trucks: float = 1
var fries_per_truck: int = 10
var dollars_per_fry: float = 0.02
var truck_cost: int = 100
var truck_interval: int = 60

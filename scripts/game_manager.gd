extends Node

@onready var cookies: Label = $ColorRect/Cookies
@onready var l_cookie: Label = $ColorRect/l_cookie
@onready var bake: Button = $ColorRect/Bake

var current_cookies: int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	bake.connect("button_down", bake_cookie)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	cookies.text = str(current_cookies)
	

func bake_cookie() -> void:
	current_cookies += 1
	

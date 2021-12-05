extends Light2D



var is_on_flash := false
var can_see := false

func _ready() -> void:
	hide()

func flashlight_rotacion() -> void:
	
	look_at(get_global_mouse_position())
	rotation_degrees += 90
	

func flashlight_power() -> void:
	if Input.is_action_just_pressed("flashlight_power"):
		if is_on_flash == true:
			is_on_flash = false
		else:
			is_on_flash = true
	if is_on_flash == true:
		show()
	else:
		hide()


func _physics_process(delta: float) -> void:
	flashlight_rotacion()
	flashlight_power()


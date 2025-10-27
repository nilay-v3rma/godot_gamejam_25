extends Node2D

var current_side: int = 0 # -1 is left and 1 is right and 0 is "not shooting rn"
var chosen_student: Student
var current_card_data: CardData

@onready var angle_bar = $HScrollBar
@onready var power_bar = $HScrollBar2
@onready var aim_line: Line2D = $Line2D
@onready var shoot_button = $Shoot

var screen_size

func _ready():
	#visible = false
	screen_size = get_viewport().get_visible_rect().size
	#angle_bar.global_position = Vector2(420, 420)
	#power_bar.global_position = Vector2(420, 340)
	#shoot_button.global_position = Vector2(510, 500)
	move_out()

func _physics_process(delta):
	aim_line.rotation_degrees = angle_bar.value
	aim_line.points[1].x = aim_line.points[0].x + power_bar.value

func move_to(student_position):
	global_position = student_position
	aim_line.position = Vector2(0, 0)
	power_bar.global_position = Vector2(420, 420)
	angle_bar.global_position = Vector2(420, 340)
	shoot_button.global_position = Vector2(510, 500)

func move_out():
	global_position = Vector2(1000, 5000) # disappear.
func spawn_and_launch_firecracker(angle: float, power: float, base_position: Vector2):
	"""Create and launch a firecracker with the given parameters"""
	# Load the firecracker scene
	if not current_card_data:
		return
	var firecracker_scene = load(current_card_data.scene)
	var firecracker: Firecracker = firecracker_scene.instantiate()
	
	# Add firecracker to the scene
	get_tree().current_scene.add_child(firecracker)
	
	## we don't use this stuff no longer
	# # Setup firecracker with card data if available
	#if current_card_data:
		#firecracker.setup_with_card_data(current_card_data)
	#else:
		#print("Warning: No card data available for firecracker")
	
	# Launch the firecracker from the base position
	firecracker.launch(angle, power, base_position)
	
	print("Firecracker spawned and launched!")

func _on_cardview_card_deployed_left_side(slot_index: int, card_id: int) -> void:
	current_card_data = CardDBInst.get_card(card_id)
	current_side = -1
	if not current_card_data:
		next_turn()

func _on_cardview_card_deployed_right_side(slot_index: int, card_id: int) -> void:
	current_card_data = CardDBInst.get_card(card_id)
	current_side = 1
	if not current_card_data:
		next_turn()

func _on_student_chosen(student: Student):
	if student.side != current_side:
		return
	chosen_student = student
	move_to(student.global_position)

func next_turn():
	move_out()
	var next_side = current_side * -1
	if next_side == -1:
		get_tree().current_scene.find_child("cardsystem").visible = true
	elif next_side == 1:
		get_tree().current_scene.find_child("cardsystem2").visible = true
	
	current_side = 0

func _on_shoot_pressed() -> void:
	spawn_and_launch_firecracker(aim_line.rotation_degrees, power_bar.value, global_position)
	next_turn()

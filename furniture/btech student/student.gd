extends Draggable
class_name Student

var screen_size 

var side # -1 = left, 1 = right, 0 = none

signal touched(student: Student) # CONSENSUALLY, ALL CHARACTERS DEPICTED ARE LEGALLY ADULTS

func _ready():
	super()
	screen_size = get_viewport().get_visible_rect().size
	var shootingsystem = get_tree().current_scene.find_child("versusshootsystem", true)
	if shootingsystem:
		touched.connect(shootingsystem._on_student_chosen)

func _physics_process(delta: float) -> void:
	if (self.global_position.x < screen_size.x/2):
		side = -1
		$sprite.flip_h = false
	else:
		side = 1
		$sprite.flip_h = true

func _input(event: InputEvent) -> void:
	super(event)
	if draggable:
		return  # not aiming yet
	if event is InputEventScreenTouch:
		if event.pressed:
			# Check if this touch is on this body
			var space_state = get_world_2d().direct_space_state
			var query = PhysicsPointQueryParameters2D.new()
			query.position = event.position
			var hits = space_state.intersect_point(query)
			for hit in hits:
				if hit["collider"] == self:
					touched.emit(self)
					break

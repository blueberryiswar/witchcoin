extends Node

@onready var pawn = get_parent()
@onready var task_manager = $"../TaskManager"


enum PawnAction {Idle, DoingSubTask}

var current_action : PawnAction = PawnAction.Idle
var current_task : Task = null
var target_destination : Vector2 = Vector2.ZERO
var interaction_target : Item = null

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if current_task != null:
		do_current_task(delta)
	else:
		current_task = task_manager.request_task()

func do_current_task(delta):
	var sub_task = current_task.get_current_sub_task()
	
	if current_action == PawnAction.Idle:
		start_current_subtask(sub_task)
		
	if target_destination != Vector2.ZERO:
		if pawn.global_position == target_destination:
			current_task.on_reached_destination()
			on_finished_subtask()
			target_destination = Vector2.ZERO
	
	if interaction_target != null:
		if interaction_target.is_finished():
			interaction_target.remove()
			current_task.on_finish_sub_task()
			on_finished_subtask()

func start_current_subtask(sub_task : Task):
	print("Starting Subtask: " + Task.TaskType.keys()[sub_task.task_type])
	current_action = PawnAction.DoingSubTask
	
	match sub_task.task_type:
		Task.TaskType.FindItem:
			var target_item = pawn.find_nearest_item(sub_task.target_item_type)
			if target_item == null:
				print("no item found")
				current_task.finish()
			else:
				current_task.on_found_item(target_item)
			on_finished_subtask()
		Task.TaskType.WalkTo:
			pawn.move_to(sub_task.target_item.global_position)
			target_destination = sub_task.target_item.global_position
		Task.TaskType.Pickup:
			pawn.pick_up(sub_task.target_item)
			current_task.on_finish_sub_task()
			on_finished_subtask()
		Task.TaskType.Eat:
			pawn.eat()
			current_task.on_finish_sub_task()
			on_finished_subtask()
		Task.TaskType.Harvest:
			pawn.interact(sub_task.target_item)
			interaction_target = sub_task.target_item

func on_finished_subtask():
	if(current_task.is_finished()): current_task = null
	current_action = PawnAction.Idle

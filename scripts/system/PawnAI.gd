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
		if pawn.recreation:
			pawn.recreation_need -= delta * 0.05
		else:
			pawn.recreation_need += delta * 0.05
	else:
		current_task = task_manager.request_task()

func do_current_task(delta):
	var sub_task = current_task.get_current_sub_task()
	if current_action == PawnAction.Idle:
		start_current_subtask(sub_task)
		
	if target_destination != Vector2.ZERO:
		if share_grid(pawn.global_position ,target_destination):
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
				print("no item found of type: ", sub_task.target_item_type)
				current_task.finish()
			else:
				current_task.on_found_item(target_item)
			on_finished_subtask()
		Task.TaskType.WalkTo:
			if sub_task.target_item != null:
				pawn.move_to(sub_task.target_item.global_position)
				target_destination = sub_task.target_item.global_position
			else:
				current_task = null
				current_action = PawnAction.Idle
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
		Task.TaskType.WalkToRandom:
			var random_pos = pawn.random_target_position() * 16
			pawn.move_to(random_pos)
			target_destination = random_pos
		Task.TaskType.WalkToStorage:
			var storage = pawn.path_finder.find_nearest_storage(pawn.global_position)
			if storage != Vector2.ZERO:
				pawn.move_to(storage)
				target_destination = storage
			else:
				print("No storage area found")
				current_task = null
				current_action = PawnAction.Idle
				pawn.drop_item()
		Task.TaskType.Store:
			pawn.drop_item()
			current_task.on_finish_sub_task()
			on_finished_subtask()
		Task.TaskType.Build:
			sub_task.target_item.tryBuild(1)
			
func on_finished_subtask():
	if(current_task.is_finished()): current_task = null
	current_action = PawnAction.Idle
	
func share_grid(pawn_pos, target_pos) -> bool:
	return floor(pawn_pos/16) == floor(target_pos/16)

func _on_pawn_abort_task():
	current_task = null
	current_action = PawnAction.Idle

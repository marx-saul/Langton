extends Node

const cons = preload("res://Script/cons.gd")

var generation:int
var is_stopped:bool = false

const cell_num_x:int = 80
const cell_num_y:int = 80
const cell_size_x:int = 8
const cell_size_y:int = 8
var ants_data: Array
var ants_dir: Array
var ants_xy: Array

func _on_h_scroll_bar_speed_value_changed(value: float) -> void:
	$LabelSpeed.text="Speed: " + str(int(value))
	$Table.sim_speed = int(value)

func _on_table_generation_proceeded() -> void:
	generation += 1
	$LabelGeneration.text = "Generation: " + str(generation)

func _on_start_stop_button_pressed() -> void:
	is_stopped = not is_stopped
	# stop simulating
	if is_stopped:
		$StartStopButton.text = "Start"
		$Table.simulating = false
	# start simulating
	else:
		$StartStopButton.text = "Stop"
		$Table.simulate()

func _on_reset_button_pressed() -> void:
	$Table.clear()
	generation = 0
	$LabelGeneration.text = "Generation: " + str(generation)
	is_stopped = true
	$StartStopButton.text = "Start"
	refresh_ants()

func refresh_ants():
	$Table.clear_ants()
	# set ants
	for i in range(ants_data.size()):
		var state_map = []
		var dir_map = []
		for j in range(cons.LANG_STATES):
			state_map.append(int(ants_data[i][j]))
		for j in range(cons.LANG_STATES, cons.LANG_STATES + cons.ORTHOGONAL_DIRS):
			dir_map.append(int(ants_data[i][j]))
		$Table.add_ant(ants_dir[i], ants_xy[i].x, ants_xy[i].y, state_map, dir_map)

func refresh_ants_edit():
	if $AntsList.selected < 0:
		$AntsEdit.text = ""
		$XEdit.text = ""
		$YEdit.text = ""
	else:
		$AntsEdit.text = ants_data[$AntsList.selected]
		$DirList.select(ants_dir[$AntsList.selected])
		$XEdit.text = str(ants_xy[$AntsList.selected].x)
		$YEdit.text = str(ants_xy[$AntsList.selected].y)

func _on_ants_list_item_selected(index: int) -> void:
	refresh_ants_edit()
	
func _on_delete_button_pressed() -> void:
	if $AntsList.get_selected_id() < 0: return
	ants_data.remove_at($AntsList.get_selected_id())
	ants_xy.remove_at($AntsList.get_selected_id())
	$AntsList.remove_item($AntsList.item_count-1)
	refresh_ants_edit()

func _on_add_button_pressed() -> void:
	ants_data.append("0123456701234567")
	ants_dir.append(0)
	ants_xy.append(Vector2i(40, 40))
	$AntsList.add_item("Ant_" + str($AntsList.item_count))
	$AntsList.select($AntsList.item_count-1)
	refresh_ants_edit()

func _on_edit_button_pressed() -> void:
	var text:String = $AntsEdit.text.substr(0, 16)
	var fixed_text:String = ""
	for char in text:
		if (char == '0' or char == '1' or char == '2' or char == '3' or char == '4' or char == '5' or char == '6' or char == '7'):
			fixed_text += char
	while fixed_text.length() < cons.LANG_STATES + cons.ORTHOGONAL_DIRS:
		fixed_text += '0'
	
	var x = int($XEdit.text) % cell_num_x
	var y = int($YEdit.text) % cell_num_y
	if x < 0: x += cell_num_x
	if y < 0: y += cell_num_y
	ants_data[$AntsList.selected] = fixed_text
	ants_dir[$AntsList.selected] = $DirList.selected
	ants_xy[$AntsList.selected] = Vector2i(x, y)
	
	refresh_ants_edit()

func _ready():
	ants_data = ["1234567026262626", "1204537666222262"]
	ants_dir = [0, 2]
	ants_xy = [Vector2i(25, 25), Vector2i(50, 50)]
	$Table.init(cell_num_x, cell_num_y, cell_size_x, cell_size_y)
	refresh_ants()
	$Table.simulate()
	refresh_ants_edit()
	$LabelSpeed.text="Speed: " + str(int($HScrollBarSpeed.value))
	$Table.sim_speed = int($HScrollBarSpeed.value)

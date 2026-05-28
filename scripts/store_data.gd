extends Node
class_name DataStorer

static func save_player_data(player:PlayerCharacter):
	var data={}
	if player.learned_spells.is_empty():return
	data["accuracy_histories"]=player.piano.equipped_spells.front().accuracy_history
	data["total_missclicks"]=player.piano.total_errors
	data["rhythm adherance"]=Sequence.beat_adherance
	save_dict_to_json(data,"")
	
	pass
static var last_path="user://data.txt"
static func get_last_data():
	var file := FileAccess.open(last_path, FileAccess.READ)
	if file == null:
		print("Failed to open file for writing: ",last_path)
		return
	var data=file.get_as_text()
	var dic=JSON.parse_string(data)
	return dic	
	pass	
static func save_dict_to_json(data: Dictionary, file_path: String) -> void:
	# Convert dictionary to JSON string
	var json_string := JSON.stringify(data)
	last_path="user://" +file_path+"data.txt"
	# Open file for writing (creates or overwrites file)
	var file := FileAccess.open("user://" +file_path+"data.txt", FileAccess.WRITE)
	if file == null:
		print("Failed to open file for writing: ","user://" +file_path+"data.txt")
		return

	# Store JSON string in file
	file.store_string(json_string)
	file.close()

	print("Data saved to: ", file_path)

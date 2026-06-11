extends Node
class_name DataStorer
static var last_text="gamed"
static func save_player_data(player:PlayerCharacter,text):
	var data={}
	if player.learned_spells.is_empty():return
	data["accuracy_histories"]=player.piano.equipped_spells.front().accuracy_history
	data["total_missclicks"]=player.piano.total_errors
	data["rhythm adherance"]=Sequence.beat_adherance
	save_dict_to_json(data,text)
	last_text=text
	
	pass
static var last_path="user://gameddata.txt"
static var spell_name_path="user://spell_names.txt"
static func delete_spell(spell_name):
	var spell_names=get_data(spell_name_path)
	if spell_names==null:
		spell_names=[]
	spell_names.erase(spell_name)	
	store_data(spell_name_path,spell_names)
	
	pass	
static func get_data(path):
	var file := FileAccess.open(path, FileAccess.READ)
	if file == null:
		print("Failed to open file for writing: ",path)
		return
	var data=file.get_as_text()
	var dic=JSON.parse_string(data)
	return dic	
	pass
static func get_stored_spell(spell_name):
	return get_data("user://custom_spells/"+spell_name+".txt")
	pass;	
static func store_data(path,data):
	var json_string := JSON.stringify(data)
	# Open file for writing (creates or overwrites file)
	var file := FileAccess.open(path, FileAccess.WRITE)
	if file == null:
		print("Failed to open file for writing: ","user://" +path)
		return

	# Store JSON string in file
	file.store_string(json_string)
	file.close()
	pass	
static func get_last_data():
	return get_data(last_path)
		
static func store_custom_spell(data:Dictionary):
	var spell_names=get_data(spell_name_path)
	if spell_names==null:
		spell_names=[]
	spell_names.append(data["Name"])	
	store_data(spell_name_path,spell_names)
	store_data("user://custom_spells/"+data["Name"]+".txt",data)
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

class_name L

static var debug=true
static var error=true
static var message=true

static func e(string:String):
	if not error:return
	push_error("ERROR: "+string)
	
static func d(string:String):
	if not debug:return
	print_rich("[color=green][b] DEBUG"+string+"[/b][/color]") # Prints "Hello world!", in green with a bold font.("DEBUG: "+string)
		
	
static func l(string:String):
	if not message:return
	print_rich("[color=blue] Log"+string+"[/color]") # Prints "Hello world!", in green with a bold font.("DEBUG: "+string)
	

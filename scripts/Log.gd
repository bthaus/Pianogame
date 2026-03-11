class_name l

static var debug=true
static var error=true
static var message=true

static func e(string:String):
	if not error:return
	print_rich("[color=red][b] ERROR: "+string+"[/b][/color]") # Prints "Hello world!", in green with a bold font.("DEBUG: "+string)
	
	
static func d(string:String):
	if not debug:return
	print_rich("[color=pale_green][b] DEBUG: "+string+"[/b][/color]") # Prints "Hello world!", in green with a bold font.("DEBUG: "+string)
		
	
static func l(string:String):
	if not message:return
	print_rich("[color=bisque] Log: "+string+"[/color]") # Prints "Hello world!", in green with a bold font.("DEBUG: "+string)
	

extends SceneTree

const CI_PROJECT_PATH := "ci-project-path"
const OVERRIDE_OPTIONS := "override-options"
const OVERRIDE_OPTIONS_DELIMITER := " "

class Replacement:
	var key := ""
	var val := ""
	
	func _init(p_key: String, p_val: String) -> void:
		key = p_key
		val = p_val

func _initialize() -> void:
	print("Processing overrides")
	print("Note: Overrides MUST be separated by a space")
	
	#region Arg parsing
	
	var args: Array = OS.get_cmdline_args()
	
	print("Handling:\n%s" % str(args))
	
	var project_path := ProjectSettings.globalize_path("res://")
	## @type: Dictionary<String, Replacement> - Path to file: Replacement
	var overrides := {}
	
	var count: int = 0
	while count < args.size():
		var arg: String = args[count].lstrip("-")
		
		if not (arg.begins_with(CI_PROJECT_PATH) or arg.begins_with(OVERRIDE_OPTIONS)):
			printerr("Skipping arg %s" % arg)
			count += 1
			continue
		
		count += 1
		
		if count >= args.size():
			printerr("Bad override")
			quit(1)
			return
		
		var value: String = args[count]
		if value.begins_with("-"):
			printerr("Invalid option: %s %s" % [arg, value])
			printerr("Aborting")
			return
		
		if arg.begins_with(CI_PROJECT_PATH):
			project_path = value
			count += 1
			continue
		elif arg.begins_with(OVERRIDE_OPTIONS):
			var split: PoolStringArray = value.split(OVERRIDE_OPTIONS_DELIMITER, false)
			for override in split:
				var override_split: PoolStringArray = override.split("=", false, 1)
				if override_split.size() != 2:
					printerr("Invalid override option, aborting")
					return
				
				overrides[arg] = Replacement.new(override_split[0], override_split[1])
				
			count += 1
			continue
		else:
			printerr("Unhandled flag %s" % arg)
			count += 1
			continue
	
	#endregion
	
	var file := File.new()
	var dir := Directory.new()
	if not dir.dir_exists(project_path):
		printerr("Project path %s does not exist %s, aborting" % project_path)
		return
	
	for path in overrides.keys():
		var val: Replacement = overrides[path]
		
		print("Setting override for file: %s" % path)
		
		var file_path: String = "%s/%s" % [project_path, path]
		if file.open(file_path, File.WRITE_READ) != OK:
			printerr("Invalid file %s/%s, aborting" % [project_path, path])
			return
		
		var reconstructed_file := PoolStringArray()
		
		var file_lines := file.get_as_text().split("\n")
		for line in file_lines:
			if not line.begins_with("var") or not line.begins_with("const"):
				continue
			
			var pos: int = line.find(val.key)
			if pos < 4:
				continue
			
			print("Processing %s:%s for line:\n%s" % [val.key, val.val, line])
			
			reconstructed_file.append("%s = %s" % [line.substr(0, pos), val.val])
		
		file.store_string(reconstructed_file.join("\n"))
		
		file.close()
	
	quit(0)

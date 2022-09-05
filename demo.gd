extends CanvasLayer

#-----------------------------------------------------------------------------#
# Builtin functions                                                           #
#-----------------------------------------------------------------------------#

func _init() -> void:
	OS.center_window()
	
	var exe_path := OS.get_executable_path()
	
	var output := []
	
	OS.execute(
		exe_path,
		[
			"--script",
			ProjectSettings.globalize_path("res://addons/godot-release-override-script/override.gd"),
			"--ci-project-path",
			ProjectSettings.globalize_path("res://"),
			
			"--override-option", "demo-folder/test_script.gd:test:String='i/am/test'",
			"--override-option", "demo-folder/test_script.gd:test0='i/am/test0'",
			"--override-option", "demo-folder/test_script.gd:TEST_1='i/am/test1'",
			
			"-bleh"
		],
		true,
		output,
		true
	)
	
	print(output)

#-----------------------------------------------------------------------------#
# Connections                                                                 #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Private functions                                                           #
#-----------------------------------------------------------------------------#

#-----------------------------------------------------------------------------#
# Public functions                                                            #
#-----------------------------------------------------------------------------#

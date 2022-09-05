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
			"--override-options",
			"demo-folder/test_script.gd:test=\"i am test\" demo-folder/test_script.gd:test0='i am test0' demo-folder/test_script.gd:TEST_1='i am test 1'", "-bleh"
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

std = 'lua51'
max_line_length = false
self = false
exclude_files = {'libs/'}

ignore = {
	"412", -- Redefining an argument
	"42.", -- Shadowing a local variable, an argument, a loop variable.
	"43.", -- Shadowing an upvalue, an upvalue argument, an upvalue loop variable.
	"542", -- An empty if branch
}

globals = {

}

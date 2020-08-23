max_line_length = false
std = "lua51"

exclude_files = {
	"libs/",
	".luacheckrc"
}

ignore = {
	"11./SLASH_.*", -- Setting an undefined (Slash handler) global variable
	"11./BINDING_.*", -- Setting an undefined (Keybinding header) global variable
	"113/LE_.*", -- Accessing an undefined (Lua ENUM type) global variable
	"113/NUM_LE_.*", -- Accessing an undefined (Lua ENUM type) global variable
	"211", -- Unused local variable
	"211/F", -- Unused local variable "F"
	"211/C", -- Unused local variable "C"
	"211/L", -- Unused local variable "L"
	"212", -- Unused argument
	"213", -- Unused loop variable
	-- "231", -- Set but never accessed
	"311", -- Value assigned to a local variable is unused
	"314", -- Value of a field in a table literal is unused
	"42.", -- Shadowing a local variable, an argument, a loop variable.
	"43.", -- Shadowing an upvalue, an upvalue argument, an upvalue loop variable.
	"542", -- An empty if branch
}

globals = {

}

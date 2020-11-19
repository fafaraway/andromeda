std = 'lua51'
max_line_length = false
exclude_files = {'libs/'}
only = {
	'011', -- syntax
	'1' -- globals
}
ignore = {
	'11/SLASH_.*', -- slash handlers
	'1/[A-Z][A-Z][A-Z0-9_]+' -- three letter+ constants
}

globals = {

}

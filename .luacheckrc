std = 'lua51'
max_line_length = false
quiet = 1 -- suppress report output for files without warnings
exclude_files = {'libs/'}

ignore = {
	'2/self', -- unused argument self
	'2/event', -- unused argument event
	'3/event', -- unused value event
	'4', -- shadowing
}

globals = {

}

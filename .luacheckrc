std = 'lua51'
exclude_files = {'libs/'}
ignore = {
	'2/self', -- unused argument self
	'2/event', -- unused argument event
	'3/event', -- unused value event
	'4', -- shadowing
	'542', -- empty if branch
	'631', -- line is too long
}


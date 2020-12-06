local LDD = LibStub('LibDropDown')
LDD:RegisterStyle('MENU', {
	padding = 10,
	spacing = 2,
	backdrop = {
		-- Sourced from UIDropDownListTemplate in FrameXML/UIDropDownMenuTemplates
		bgFile = [[Interface\ChatFrame\ChatFrameBackground]],
		edgeFile = [[Interface\ChatFrame\ChatFrameBackground]], edgeSize = 1,
		--tile = true, tileSize = 16,
		insets = {left = 1, right = 1, top = 1, bottom = 1}
	},
	-- Sourced from TOOLTIP_DEFAULT_BACKGROUND_COLOR in SharedXML/SharedUIPanelTemplates.lua
	backdropColor = CreateColor(.1, .1, .1, .75),
	-- Sourced from TOOLTIP_DEFAULT_COLOR in SharedXML/SharedUIPanelTemplates.lua
	backdropBorderColor = CreateColor(.04, .04, .04),
})

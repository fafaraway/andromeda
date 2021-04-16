local F, C = unpack(select(2, ...))

local function ReskinEventTraceButton(button)
	F.Reskin(button)
	button.NormalTexture:SetAlpha(0)
	button.MouseoverOverlay:SetAlpha(0)
end

local function reskinScrollArrow(self, direction)
	self.Texture:SetAlpha(0)
	local tex = self:CreateTexture(nil, "ARTWORK")
	tex:SetAllPoints()
	F.CreateBDFrame(tex, .25)
	F.SetupArrow(tex, direction)
end

local function ReskinEventTraceScroll(scrollBar)
	F.StripTextures(scrollBar)
	reskinScrollArrow(scrollBar.Back, "up")
	reskinScrollArrow(scrollBar.Forward, "down")

	local thumb = scrollBar.Track.Thumb
	F.StripTextures(thumb, 0)
	F.CreateBDFrame(thumb, 0, true)
end

C.Themes["Blizzard_EventTrace"] = function()
	F.ReskinPortraitFrame(EventTrace)

	local subtitleBar = EventTrace.SubtitleBar
	F.ReskinFilterButton(subtitleBar.OptionsDropDown)

	local logBar = EventTrace.Log.Bar
	local filterBar = EventTrace.Filter.Bar
	F.ReskinEditBox(logBar.SearchBox)

	ReskinEventTraceScroll(EventTrace.Log.Events.ScrollBar)
	ReskinEventTraceScroll(EventTrace.Filter.ScrollBar)

	local buttons = {
		subtitleBar.ViewLog,
		subtitleBar.ViewFilter,
		logBar.DiscardAllButton,
		logBar.PlaybackButton,
		logBar.MarkButton,
		filterBar.DiscardAllButton,
		filterBar.UncheckAllButton,
		filterBar.CheckAllButton,
	}
	for _, button in pairs(buttons) do
		ReskinEventTraceButton(button)
	end
end

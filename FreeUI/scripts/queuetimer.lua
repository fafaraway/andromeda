local F, C = unpack(select(2, ...))

local r, g, b = unpack(C.class)

local LFD_QUEUE_TIMEOUT = 40
local count = 0

local timer = CreateFrame("StatusBar", "FreeUI_QueueTimer", FreeUIMenubar)
timer:SetPoint("TOPLEFT")
timer:SetPoint("TOPRIGHT")
timer:SetHeight(1)
timer:SetStatusBarTexture(C.media.backdrop)
timer:SetStatusBarColor(r, g, b)
timer:SetMinMaxValues(0, LFD_QUEUE_TIMEOUT)
timer:Hide()

timer:SetScript("OnHide", function(self)
	count = 0
	self:SetValue(0)
end)

timer:SetScript("OnUpdate", function(self, elapsed)
	count = count + elapsed
	if count < LFD_QUEUE_TIMEOUT then
		self:SetValue(count)
	else
		self:Hide()
	end
end)

timer:RegisterEvent("LFG_PROPOSAL_SHOW")
timer:RegisterEvent("LFG_PROPOSAL_FAILED")
timer:RegisterEvent("LFG_PROPOSAL_SUCCEEDED")
timer:SetScript("OnEvent", function(self, event)
	self:SetShown(event == "LFG_PROPOSAL_SHOW")
end)
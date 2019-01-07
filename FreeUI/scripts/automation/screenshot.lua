local F, C, L = unpack(select(2, ...))

local f = CreateFrame('Frame')
f:Hide()
f:SetScript('OnUpdate', function(_, elapsed)
	f.delay = f.delay - elapsed
	if f.delay < 0 then
		Screenshot()
		f:Hide()
	end
end)

local function autoScreenShot(event)
	if not C.automation.autoScreenShot then
		F:UnregisterEvent(event, autoScreenShot)
	else
		f.delay = 1
		f:Show()
	end
end
F:RegisterEvent('ACHIEVEMENT_EARNED', autoScreenShot)

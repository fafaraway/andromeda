local F, C = unpack(select(2, ...))

local function reskinHelpTips(self)
	for frame in self.framePool:EnumerateActive() do
		if not frame.styled then
			if frame.OkayButton then F.Reskin(frame.OkayButton) end
			if frame.CloseButton then F.ReskinClose(frame.CloseButton) end

			frame.styled = true
		end
	end
end

tinsert(C.BlizzThemes, function()
	if not FREE_ADB.reskin_blizz then return end

	reskinHelpTips(HelpTip)
	hooksecurefunc(HelpTip, "Show", reskinHelpTips)
end)

local F, C = unpack(select(2, ...))

local function reskinHelpTips(self)
    for frame in self.framePool:EnumerateActive() do
        if not frame.styled then
            if frame.OkayButton then
                F.Reskin(frame.OkayButton)
            end
            if frame.CloseButton then
                F.ReskinClose(frame.CloseButton)
            end

            frame.styled = true
        end
    end
end

table.insert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    reskinHelpTips(_G.HelpTip)
    hooksecurefunc(_G.HelpTip, 'Show', reskinHelpTips)
end)

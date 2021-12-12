local F, C = unpack(select(2, ...))

local function ReskinEventTraceButton(button)
    F.Reskin(button)
    button.NormalTexture:SetAlpha(0)
    button.MouseoverOverlay:SetAlpha(0)
end

local function ReskinScrollChild(self)
    for i = 1, self.ScrollTarget:GetNumChildren() do
        local child = select(i, self.ScrollTarget:GetChildren())
        local hideButton = child and child.HideButton
        if hideButton and not hideButton.styled then
            F.ReskinClose(hideButton)
            hideButton:ClearAllPoints()
            hideButton:SetPoint('LEFT', 3, 0)

            local checkButton = child.CheckButton
            if checkButton then
                F.ReskinCheck(checkButton)
                checkButton:SetSize(22, 22)
            end

            hideButton.styled = true
        end
    end
end

local function ReskinEventTraceScrollBox(frame)
    frame:DisableDrawLayer('BACKGROUND')
    F.CreateBDFrame(frame, .25)
    hooksecurefunc(frame, 'Update', ReskinScrollChild)
end

local function ReskinEventTraceFrame(frame)
    ReskinEventTraceScrollBox(frame.ScrollBox)
    F.ReskinTrimScroll(frame.ScrollBar)
end

C.Themes['Blizzard_EventTrace'] = function()
    F.ReskinPortraitFrame(_G.EventTrace)

    local subtitleBar = _G.EventTrace.SubtitleBar
    F.ReskinFilterButton(subtitleBar.OptionsDropDown)

    local logBar = _G.EventTrace.Log.Bar
    local filterBar = _G.EventTrace.Filter.Bar
    F.ReskinEditBox(logBar.SearchBox)

    ReskinEventTraceFrame(_G.EventTrace.Log.Events)
    ReskinEventTraceFrame(_G.EventTrace.Log.Search)
    ReskinEventTraceFrame(_G.EventTrace.Filter)

    local buttons = {
        subtitleBar.ViewLog,
        subtitleBar.ViewFilter,
        logBar.DiscardAllButton,
        logBar.PlaybackButton,
        logBar.MarkButton,
        filterBar.DiscardAllButton,
        filterBar.UncheckAllButton,
        filterBar.CheckAllButton
    }
    for _, button in pairs(buttons) do
        ReskinEventTraceButton(button)
    end
end

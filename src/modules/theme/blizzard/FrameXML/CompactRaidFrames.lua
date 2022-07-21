local F, C = unpack(select(2, ...))

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    if not _G.CompactRaidFrameManagerToggleButton then
        return
    end

    _G.CompactRaidFrameManagerToggleButton:SetNormalTexture('Interface\\Buttons\\UI-ColorPicker-Buttons')
    _G.CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(0.15, 0.39, 0, 1)
    _G.CompactRaidFrameManagerToggleButton:SetSize(15, 15)
    hooksecurefunc('CompactRaidFrameManager_Collapse', function()
        _G.CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(0.15, 0.39, 0, 1)
    end)
    hooksecurefunc('CompactRaidFrameManager_Expand', function()
        _G.CompactRaidFrameManagerToggleButton:GetNormalTexture():SetTexCoord(0.86, 1, 0, 1)
    end)

    local buttons = {
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleTank,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleHealer,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterRoleDamager,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup1,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup2,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup3,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup4,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup5,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup6,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup7,
        _G.CompactRaidFrameManagerDisplayFrameFilterOptionsFilterGroup8,
        _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateRolePoll,
        _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsCountdown,
        _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsInitiateReadyCheck,
        --CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton,
        _G.CompactRaidFrameManagerDisplayFrameLockedModeToggle,
        _G.CompactRaidFrameManagerDisplayFrameHiddenModeToggle,
        _G.CompactRaidFrameManagerDisplayFrameConvertToRaid,
    }
    for _, button in pairs(buttons) do
        for i = 1, 9 do
            select(i, button:GetRegions()):SetAlpha(0)
        end
        F.Reskin(button)
    end
    _G.CompactRaidFrameManagerDisplayFrameLeaderOptionsRaidWorldMarkerButton:SetNormalTexture(
        'Interface\\RaidFrame\\Raid-WorldPing'
    )

    for i = 1, 8 do
        select(i, _G.CompactRaidFrameManager:GetRegions()):SetAlpha(0)
    end
    select(1, _G.CompactRaidFrameManagerDisplayFrameFilterOptions:GetRegions()):SetAlpha(0)
    select(1, _G.CompactRaidFrameManagerDisplayFrame:GetRegions()):SetAlpha(0)
    select(4, _G.CompactRaidFrameManagerDisplayFrame:GetRegions()):SetAlpha(0)

    local bd = F.SetBD(_G.CompactRaidFrameManager)
    bd:SetPoint('TOPLEFT')
    bd:SetPoint('BOTTOMRIGHT', -9, 9)
    F.ReskinDropDown(_G.CompactRaidFrameManagerDisplayFrameProfileSelector)
    F.ReskinCheckbox(_G.CompactRaidFrameManagerDisplayFrameEveryoneIsAssistButton)
end)

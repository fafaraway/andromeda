local _, private = ...

--[[ Lua Globals ]]
-- luacheck: globals next

--[[ Core ]]
local Aurora = private.Aurora
local Base, Scale = Aurora.Base, Aurora.Scale
local Hook, Skin = Aurora.Hook, Aurora.Skin

do --[[ AddOns\Blizzard_CompactRaidFrameManager.lua ]]
    function Hook.CompactRaidFrameManager_Toggle(self)
        if self.collapsed then
            Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowRight")
        else
            Base.SetTexture(self.toggleButton:GetNormalTexture(), "arrowLeft")
        end
     end
    function Hook.CompactRaidFrameManager_UpdateOptionsFlowContainer(self)
        local height = self:GetHeight() - 40
        self:SetHeight(height + Scale.Value(40))
    end
end

do --[[ AddOns\Blizzard_CompactRaidFrameManager.xml ]]
    function Skin.CRFManagerFilterButtonTemplate(button)
        Skin.UIMenuButtonStretchTemplate(button)
        button.selectedHighlight:SetColorTexture(1, 1, 0, 0.3)
        button.selectedHighlight:SetPoint("TOPLEFT", button._auroraBDFrame, 1, -1)
        button.selectedHighlight:SetPoint("BOTTOMRIGHT", button._auroraBDFrame, -1, 1)
    end
    Skin.CRFManagerFilterRoleButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    Skin.CRFManagerFilterGroupButtonTemplate = Skin.CRFManagerFilterButtonTemplate
    function Skin.CRFManagerRaidIconButtonTemplate(button)
        button:SetSize(24, 24)
        button:SetPoint(button:GetPoint())

        button:GetNormalTexture():SetSize(24, 24)
    end
end

function private.AddOns.Blizzard_CompactRaidFrames()
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameReservationManager --
    ----====####$$$$%%%%%%%%%%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameContainer --
    ----====####$$$$%%%%%%%%$$$$####====----

    ----====####$$$$%%%%%%$$$$####====----
    -- Blizzard_CompactRaidFrameManager --
    ----====####$$$$%%%%%%$$$$####====----
    _G.hooksecurefunc("CompactRaidFrameManager_Toggle", Hook.CompactRaidFrameManager_Toggle)

    local CompactRaidFrameManager = _G.CompactRaidFrameManager
    CompactRaidFrameManager:DisableDrawLayer("ARTWORK")
    Base.SetBackdrop(CompactRaidFrameManager)

    local toggleButton = CompactRaidFrameManager.toggleButton
    toggleButton:SetPoint("RIGHT", -1, 0)
    toggleButton:SetScript("OnMouseDown", private.nop)
    toggleButton:SetScript("OnMouseUp", private.nop)

    local arrow = toggleButton:GetNormalTexture()
    arrow:SetPoint("TOPLEFT", 3, -5)
    arrow:SetPoint("BOTTOMRIGHT", -3, 5)
    Base.SetTexture(arrow, "arrowRight")
    toggleButton._auroraHighlight = {arrow}
    Base.SetHighlight(toggleButton, "texture")

    local displayFrame = CompactRaidFrameManager.displayFrame
    local displayFrameName = displayFrame:GetName()
    displayFrame:GetRegions():Hide()

    local headerDelineator = _G[displayFrameName.."HeaderDelineator"]
    headerDelineator:SetColorTexture(1, 1, 1)
    headerDelineator:SetPoint("TOPLEFT", 0, -27)
    headerDelineator:SetPoint("TOPRIGHT", -7, -27)
    headerDelineator:SetHeight(1)

    local optionsButton = _G[displayFrameName.."OptionsButton"]
    Skin.UIPanelInfoButton(optionsButton)

    displayFrame.optionsFlowContainer:SetPoint("TOPLEFT", headerDelineator, "BOTTOMLEFT", -10, -1)

    Skin.UIDropDownMenuTemplate(displayFrame.profileSelector)

    local filterOptions = displayFrame.filterOptions
    local footerDelineator = _G[filterOptions:GetName().."FooterDelineator"]
    footerDelineator:SetColorTexture(1, 1, 1)
    footerDelineator:SetPoint("BOTTOMLEFT", 0, 7)
    footerDelineator:SetPoint("BOTTOMRIGHT", 4, 7)
    footerDelineator:SetHeight(1)

    Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleTank)
    Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleHealer)
    Skin.CRFManagerFilterRoleButtonTemplate(filterOptions.filterRoleDamager)
    for i = 1, 8 do
        Skin.CRFManagerFilterGroupButtonTemplate(filterOptions["filterGroup"..i])
    end

    Skin.UIMenuButtonStretchTemplate(displayFrame.lockedModeToggle)
    Skin.UIMenuButtonStretchTemplate(displayFrame.hiddenModeToggle)
    Skin.UIMenuButtonStretchTemplate(displayFrame.convertToRaid)

    local icons = {displayFrame.raidMarkers:GetChildren()}
    for i, icon in next, icons do
        Skin.CRFManagerRaidIconButtonTemplate(icon)
    end

    local leaderOptions = displayFrame.leaderOptions
    Skin.UIMenuButtonStretchTemplate(leaderOptions.rolePollButton)
    Skin.UIMenuButtonStretchTemplate(leaderOptions.readyCheckButton)
    Skin.UIMenuButtonStretchTemplate(_G[leaderOptions:GetName().."RaidWorldMarkerButton"])

    Skin.UICheckButtonTemplate(displayFrame.everyoneIsAssistButton)

    --[[ Scale ]]--
    _G.hooksecurefunc("CompactRaidFrameManager_UpdateOptionsFlowContainer", Hook.CompactRaidFrameManager_UpdateOptionsFlowContainer)

    _G.CompactRaidFrameManager:SetSize(200, 140)
    _G.CompactRaidFrameManager:SetPoint("TOPLEFT", -182, -140)
    _G.CompactRaidFrameManager._auroraNoSetHeight = true

    _G.CompactRaidFrameManager.toggleButton:SetSize(16, 64)
    _G.CompactRaidFrameManager.toggleButton:GetNormalTexture()._auroraNoSetSize = true

    displayFrame.label:SetPoint("TOPLEFT", 10, -8)
    displayFrame.memberCountLabel:SetPoint("TOPRIGHT", -28, -8)

    optionsButton:SetPoint("TOPRIGHT", -9, -7)

    displayFrame.optionsFlowContainer:SetPoint("RIGHT", -10, 0)

    displayFrame.filterOptions:SetSize(200, 85)
    displayFrame.filterOptions.filterRoleTank:SetPoint("TOPLEFT", 19, 4)

    displayFrame.raidMarkers:SetSize(200, 50)

    displayFrame.leaderOptions:SetSize(200, 45)
    displayFrame.leaderOptions.rolePollButton:SetPoint("TOPLEFT", 20, -5)
    _G[displayFrame.leaderOptions:GetName().."RaidWorldMarkerButton"].Icon:SetSize(14, 14)
end

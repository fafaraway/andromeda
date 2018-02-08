local _, private = ...

--[[ Lua Globals ]]
local next = _G.next

-- [[ Core ]]
local Aurora = private.Aurora
local Base, Hook, Skin = Aurora.Base, Aurora.Hook, Aurora.Skin

do --[[ FrameXML\ReputationFrame.lua ]]
    function Hook.ReputationFrame_OnShow(self)
        -- The TOPRIGHT anchor for ReputationBar1 is set in C code
        _G.ReputationBar1:SetPoint("TOPRIGHT", -34, -49)
    end
    function Hook.ReputationFrame_SetRowType(factionRow, isChild, isHeader, hasRep)
        if isHeader then
            for _, texture in next, factionRow._auroraHighlight do
                texture:Hide()
            end
        else
            for _, texture in next, factionRow._auroraHighlight do
                texture:Show()
            end
        end
    end
    function Hook.ReputationFrame_Update(self)
        for i = 1, _G.NUM_FACTIONS_DISPLAYED do
            local factionRowName = "ReputationBar"..i
            local factionRow = _G[factionRowName]
            local factionButton = _G[factionRowName.."ExpandOrCollapseButton"]
            local factionBackground = _G[factionRowName.."Background"]

            if not factionRow.index then return end

            if factionRow.isCollapsed then
                factionButton:SetNormalTexture("Interface\\Buttons\\UI-PlusButton-Up")
            else
                factionButton:SetNormalTexture("Interface\\Buttons\\UI-MinusButton-Up")
            end

            local _, _, _, _, _, _, atWarWith = _G.GetFactionInfo(factionRow.index)
            if atWarWith then
                factionBackground:SetColorTexture(0.6, 0.2, 0.2)
            else
                factionBackground:SetColorTexture(Aurora.buttonColor:GetRGB())
            end

            if factionRow.index == _G.GetSelectedFaction() then
                if ( _G.ReputationDetailFrame:IsShown() ) then
                    for _, texture in next, factionRow._auroraHighlight do
                        texture:SetColorTexture(Aurora.highlightColor:GetRGB())
                    end
                end
            else
                for _, texture in next, factionRow._auroraHighlight do
                    texture:SetColorTexture(factionRow._returnColor:GetRGB())
                end
            end
        end
    end
end

do --[[ FrameXML\ReputationFrame.xml ]]
    local function OnLeave(button)
        if (_G.GetSelectedFaction() ~= button.index) or (not _G.ReputationDetailFrame:IsShown()) then
            for _, texture in next, button._auroraHighlight do
                texture:SetColorTexture(button._returnColor:GetRGBA())
            end
        end
    end

    function Skin.ReputationBarTemplate(button)
        local factionRowName = button:GetName()

        local background = _G[factionRowName.."Background"]
        background:SetColorTexture(Aurora.buttonColor:GetRGB())
        background:SetPoint("TOPRIGHT")
        background:SetHeight(20)

        do -- highlight
            button._auroraHighlight = {}
            local left = button:CreateTexture(nil, "ARTWORK", nil, 3)
            left:SetColorTexture(Aurora.frameColor:GetRGB())
            left:SetPoint("TOPLEFT")
            left:SetPoint("BOTTOMLEFT")
            left:SetWidth(1)
            _G.tinsert(button._auroraHighlight, left)

            local right = button:CreateTexture(nil, "ARTWORK", nil, 3)
            right:SetColorTexture(Aurora.frameColor:GetRGB())
            right:SetPoint("TOPRIGHT")
            right:SetPoint("BOTTOMRIGHT")
            right:SetWidth(1)
            _G.tinsert(button._auroraHighlight, right)

            local top = button:CreateTexture(nil, "ARTWORK", nil, 3)
            top:SetColorTexture(Aurora.frameColor:GetRGB())
            top:SetPoint("TOPLEFT")
            top:SetPoint("TOPRIGHT")
            top:SetHeight(1)
            _G.tinsert(button._auroraHighlight, top)

            local bottom = button:CreateTexture(nil, "ARTWORK", nil, 3)
            bottom:SetColorTexture(Aurora.frameColor:GetRGB())
            bottom:SetPoint("BOTTOMLEFT")
            bottom:SetPoint("BOTTOMRIGHT")
            bottom:SetHeight(1)
            _G.tinsert(button._auroraHighlight, bottom)

            Base.SetHighlight(button, "color", nil, OnLeave)
        end

        Skin.ExpandOrCollapse(_G[factionRowName.."ExpandOrCollapseButton"])

        local statusName = factionRowName.."ReputationBar"
        local statusbar = _G[statusName]
        statusbar:ClearAllPoints()
        statusbar:SetPoint("TOPRIGHT", -2, -2)
        statusbar:SetPoint("BOTTOMLEFT", button, "BOTTOMRIGHT", -102, 2)
        _G[statusName.."LeftTexture"]:Hide()

        local statusBG = _G[statusName.."RightTexture"]
        statusBG:SetColorTexture(Aurora.frameColor:GetRGB())
        statusBG:SetDrawLayer("BACKGROUND", -3)
        statusBG:ClearAllPoints()
        statusBG:SetPoint("TOPLEFT")
        statusBG:SetPoint("BOTTOMRIGHT")

        _G[statusName.."AtWarHighlight2"]:SetAlpha(0)
        _G[statusName.."AtWarHighlight1"]:SetAlpha(0)

        _G[statusName.."Highlight2"]:SetAlpha(0)
        _G[statusName.."Highlight1"]:SetAlpha(0)

        Base.SetTexture(statusbar:GetStatusBarTexture(), "gradientUp")
    end
end

function private.FrameXML.ReputationFrame()
    _G.ReputationFrame:HookScript("OnShow", Hook.ReputationFrame_OnShow)
    _G.hooksecurefunc("ReputationFrame_SetRowType", Hook.ReputationFrame_SetRowType)
    _G.hooksecurefunc("ReputationFrame_Update", Hook.ReputationFrame_Update)

    --[[ ReputationParagonTooltipStatusBar ]]--
    Skin.TooltipProgressBarTemplate(_G.ReputationParagonTooltipStatusBar)


    --[[ ReputationFrame ]]--
    Skin.ReputationBarTemplate(_G.ReputationBar1)
    for i = 2, _G.NUM_FACTIONS_DISPLAYED do
        local factionRow = _G["ReputationBar"..i]
        factionRow:SetPoint("TOPRIGHT", _G["ReputationBar"..i - 1], "BOTTOMRIGHT", 0, -4)
        Skin.ReputationBarTemplate(factionRow)
    end
    _G.ReputationFrameFactionLabel:SetPoint("TOPLEFT", 75, -32)
    _G.ReputationFrameStandingLabel:ClearAllPoints()
    _G.ReputationFrameStandingLabel:SetPoint("TOPRIGHT", -75, -32)

    _G.ReputationListScrollFrame:SetPoint("TOPLEFT", _G.CharacterFrameInset, 4, -4)
    _G.ReputationListScrollFrame:SetPoint("BOTTOMRIGHT", _G.CharacterFrameInset, -23, 4)

    Skin.FauxScrollFrameTemplate(_G.ReputationListScrollFrame)
    local top, bottom = _G.ReputationListScrollFrame:GetRegions()
    top:Hide()
    bottom:Hide()


    --[[ ReputationDetailFrame ]]--
    _G.ReputationDetailFrame:SetPoint("TOPLEFT", _G.ReputationFrame, "TOPRIGHT", 1, -28)
    Base.SetBackdrop(_G.ReputationDetailFrame, Aurora.frameColor:GetRGBA())

    _G.ReputationDetailFactionName:SetPoint("TOPLEFT", 10, -10)
    _G.ReputationDetailFactionName:SetPoint("TOPRIGHT", -10, -10)
    _G.ReputationDetailFactionDescription:SetPoint("TOPLEFT", _G.ReputationDetailFactionName, "BOTTOMLEFT", 0, -5)
    _G.ReputationDetailFactionDescription:SetPoint("TOPRIGHT", _G.ReputationDetailFactionName, "BOTTOMRIGHT", 0, -5)

    local detailBG = _G.select(3, _G.ReputationDetailFrame:GetRegions())
    detailBG:SetPoint("TOPLEFT", 1, -1)
    detailBG:SetPoint("BOTTOMRIGHT", _G.ReputationDetailFrame, "TOPRIGHT", -1, -142)
    detailBG:SetColorTexture(Aurora.buttonColor:GetRGB())
    _G.ReputationDetailCorner:Hide()

    _G.ReputationDetailDivider:SetColorTexture(Aurora.frameColor:GetRGB())
    _G.ReputationDetailDivider:ClearAllPoints()
    _G.ReputationDetailDivider:SetPoint("BOTTOMLEFT", detailBG)
    _G.ReputationDetailDivider:SetPoint("BOTTOMRIGHT", detailBG)
    _G.ReputationDetailDivider:SetHeight(1)

    Skin.UIPanelCloseButton(_G.ReputationDetailCloseButton)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailAtWarCheckBox) -- BlizzWTF: doesn't use the template, but it should
    _G.ReputationDetailAtWarCheckBox:SetPoint("TOPLEFT", detailBG, "BOTTOMLEFT", 8, -8)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailInactiveCheckBox)
    _G.ReputationDetailInactiveCheckBox:SetPoint("LEFT", _G.ReputationDetailAtWarCheckBox, "RIGHT", 50, 0)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailMainScreenCheckBox)
    _G.ReputationDetailMainScreenCheckBox:SetPoint("TOPLEFT", _G.ReputationDetailAtWarCheckBox, "BOTTOMLEFT", 0, -6)
    Skin.OptionsSmallCheckButtonTemplate(_G.ReputationDetailLFGBonusReputationCheckBox)
    _G.ReputationDetailLFGBonusReputationCheckBox:SetPoint("TOPLEFT", _G.ReputationDetailMainScreenCheckBox, "BOTTOMLEFT", 0, -6)



    if not private.disabled.mainmenubar then
        Skin.MainMenuBarWatchBarTemplate(_G.ReputationWatchBar)
    end

    if not private.disabled.tooltips then
        Skin.GameTooltipTemplate(_G.ReputationParagonTooltip)
        Skin.EmbeddedItemTooltip(_G.ReputationParagonTooltip.ItemTooltip)
    end
end

local F, C = unpack(select(2, ...))

local function handleSpellButton(self)
    local SpellBookFrame = _G.SpellBookFrame

    if SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then
        return
    end

    local slot, slotType = SpellBook_GetSpellBookSlot(self)
    local isPassive = IsPassiveSpell(slot, SpellBookFrame.bookType)
    local name = self:GetName()
    local highlightTexture = _G[name .. 'Highlight']
    if isPassive then
        highlightTexture:SetColorTexture(1, 1, 1, 0)
    else
        highlightTexture:SetColorTexture(1, 1, 1, 0.25)
    end

    local subSpellString = _G[name .. 'SubSpellName']
    local isOffSpec = self.offSpecID ~= 0 and SpellBookFrame.bookType == _G.BOOKTYPE_SPELL
    subSpellString:SetTextColor(1, 1, 1)

    if slotType == 'FUTURESPELL' then
        local level = GetSpellAvailableLevel(slot, SpellBookFrame.bookType)
        if level and level > UnitLevel('player') then
            self.SpellName:SetTextColor(0.7, 0.7, 0.7)
            subSpellString:SetTextColor(0.7, 0.7, 0.7)
        end
    else
        if slotType == 'SPELL' and isOffSpec then
            subSpellString:SetTextColor(0.7, 0.7, 0.7)
        end
    end
    self.RequiredLevelString:SetTextColor(0.7, 0.7, 0.7)

    local ic = _G[name .. 'IconTexture']
    if ic.bg then
        ic.bg:SetShown(ic:IsShown())
    end

    if self.ClickBindingIconCover and self.ClickBindingIconCover:IsShown() then
        self.SpellName:SetTextColor(0.7, 0.7, 0.7)
    end
end

local function handleSkillButton(button)
    if not button then
        return
    end
    button:SetCheckedTexture(0)
    button:SetPushedTexture(0)
    button.IconTexture:SetInside()
    button.bg = F.ReskinIcon(button.IconTexture)
    button.highlightTexture:SetInside(button.bg)

    local nameFrame = _G[button:GetName() .. 'NameFrame']
    if nameFrame then
        nameFrame:Hide()
    end
end

tinsert(C.BlizzThemes, function()
    if not _G.ANDROMEDA_ADB.ReskinBlizz then
        return
    end

    F.ReskinPortraitFrame(_G.SpellBookFrame)
    _G.SpellBookFrame:DisableDrawLayer('BACKGROUND')
    _G.SpellBookFrameTabButton1:ClearAllPoints()
    _G.SpellBookFrameTabButton1:SetPoint('TOPLEFT', _G.SpellBookFrame, 'BOTTOMLEFT', 0, 0)

    for i = 1, 5 do
        local tab = _G['SpellBookFrameTabButton' .. i]
        if tab then
            F.ReskinTab(tab)
        end
    end

    hooksecurefunc('SpellBookFrame_Update', function()
        for i = 2, 5 do
            local tab = _G['SpellBookFrameTabButton' .. i]
            if tab then
                tab:ClearAllPoints()
                tab:SetPoint('TOPLEFT', _G['SpellBookFrameTabButton' .. (i - 1)], 'TOPRIGHT', -10, 0)
            end
        end
    end)

    for i = 1, _G.SPELLS_PER_PAGE do
        local bu = _G['SpellButton' .. i]
        local ic = _G['SpellButton' .. i .. 'IconTexture']

        _G['SpellButton' .. i .. 'SlotFrame']:SetAlpha(0)
        bu.EmptySlot:SetAlpha(0)
        bu.TextBackground:Hide()
        bu.TextBackground2:Hide()
        bu.UnlearnedFrame:SetAlpha(0)
        bu:SetCheckedTexture(0)
        bu:SetPushedTexture(0)

        ic.bg = F.ReskinIcon(ic)

        hooksecurefunc(bu, 'UpdateButton', handleSpellButton)
    end

    _G.SpellBookSkillLineTab1:SetPoint('TOPLEFT', _G.SpellBookSideTabsFrame, 'TOPRIGHT', 2, -36)

    hooksecurefunc('SpellBookFrame_UpdateSkillLineTabs', function()
        for i = 1, GetNumSpellTabs() do
            local tab = _G['SpellBookSkillLineTab' .. i]
            local nt = tab:GetNormalTexture()
            if nt then
                nt:SetTexCoord(unpack(C.TEX_COORD))
            end

            if not tab.styled then
                tab:GetRegions():Hide()
                tab:SetCheckedTexture(C.Assets.Textures.ButtonChecked)
                tab:GetHighlightTexture():SetColorTexture(1, 1, 1, 0.25)
                F.CreateBDFrame(tab, 0.25)

                tab.styled = true
            end
        end
    end)

    _G.SpellBookFrameTutorialButton.Ring:Hide()
    _G.SpellBookFrameTutorialButton:SetPoint('TOPLEFT', _G.SpellBookFrame, 'TOPLEFT', -12, 12)

    -- Professions

    local professions = {
        'PrimaryProfession1',
        'PrimaryProfession2',
        'SecondaryProfession1',
        'SecondaryProfession2',
        'SecondaryProfession3',
    }

    for i, button in pairs(professions) do
        local bu = _G[button]
        bu.professionName:SetTextColor(1, 1, 1)
        bu.missingHeader:SetTextColor(1, 1, 1)
        bu.missingText:SetTextColor(1, 1, 1)

        F.StripTextures(bu.statusBar)
        bu.statusBar:SetHeight(10)
        bu.statusBar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
        bu.statusBar:GetStatusBarTexture():SetGradient('VERTICAL', CreateColor(0, 0.6, 0, 1), CreateColor(0, 0.8, 0, 1))

        bu.statusBar.rankText:SetPoint('CENTER')
        F.CreateBDFrame(bu.statusBar, 0.25)
        if i > 2 then
            bu.statusBar:ClearAllPoints()
            bu.statusBar:SetPoint('BOTTOMLEFT', 16, 3)
        end

        handleSkillButton(bu.SpellButton1)
        handleSkillButton(bu.SpellButton2)
    end

    for i = 1, 2 do
        local bu = _G['PrimaryProfession' .. i]
        _G['PrimaryProfession' .. i .. 'IconBorder']:Hide()

        bu.professionName:ClearAllPoints()
        bu.professionName:SetPoint('TOPLEFT', 100, -4)
        bu.icon:SetAlpha(1)
        bu.icon:SetDesaturated(false)
        F.ReskinIcon(bu.icon)

        local bg = F.CreateBDFrame(bu, 0.25)
        bg:SetPoint('TOPLEFT')
        bg:SetPoint('BOTTOMRIGHT', 0, -5)
    end

    hooksecurefunc('FormatProfession', function(frame, index)
        if index then
            local _, texture = GetProfessionInfo(index)

            if frame.icon and texture then
                frame.icon:SetTexture(texture)
            end
        end
    end)

    F.CreateBDFrame(_G.SecondaryProfession1, 0.25)
    F.CreateBDFrame(_G.SecondaryProfession2, 0.25)
    F.CreateBDFrame(_G.SecondaryProfession3, 0.25)
    F.ReskinArrow(_G.SpellBookPrevPageButton, 'left')
    F.ReskinArrow(_G.SpellBookNextPageButton, 'right')
    _G.SpellBookPageText:SetTextColor(0.8, 0.8, 0.8)

    hooksecurefunc('UpdateProfessionButton', function(self)
        local spellIndex = self:GetID() + self:GetParent().spellOffset
        local isPassive = IsPassiveSpell(spellIndex, _G.SpellBookFrame.bookType)
        if isPassive then
            self.highlightTexture:SetColorTexture(1, 1, 1, 0)
        else
            self.highlightTexture:SetColorTexture(1, 1, 1, 0.25)
        end
        if self.spellString then
            self.spellString:SetTextColor(1, 1, 1)
        end
        if self.subSpellString then
            self.subSpellString:SetTextColor(1, 1, 1)
        end
    end)
end)

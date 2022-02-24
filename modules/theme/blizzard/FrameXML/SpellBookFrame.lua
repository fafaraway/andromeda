local F, C = unpack(select(2, ...))

table.insert(
    C.BlizzThemes,
    function()
        F.ReskinPortraitFrame(_G.SpellBookFrame)
        _G.SpellBookFrame:DisableDrawLayer('BACKGROUND')
        _G.SpellBookFrameTabButton1:ClearAllPoints()
        _G.SpellBookFrameTabButton1:SetPoint('TOPLEFT', _G.SpellBookFrame, 'BOTTOMLEFT', 0, 0)

        for i = 1, 5 do
            F.ReskinTab(_G['SpellBookFrameTabButton' .. i])
        end

        for i = 1, _G.SPELLS_PER_PAGE do
            local bu = _G['SpellButton' .. i]
            local ic = _G['SpellButton' .. i .. 'IconTexture']

            _G['SpellButton' .. i .. 'SlotFrame']:SetAlpha(0)
            bu.EmptySlot:SetAlpha(0)
            bu.TextBackground:Hide()
            bu.TextBackground2:Hide()
            bu.UnlearnedFrame:SetAlpha(0)
            bu:SetCheckedTexture('')
            bu:SetPushedTexture('')

            ic.bg = F.ReskinIcon(ic)
        end

        hooksecurefunc(
            'SpellButton_UpdateButton',
            function(self)
                if _G.SpellBookFrame.bookType == _G.BOOKTYPE_PROFESSION then
                    return
                end

                local slot, slotType = _G.SpellBook_GetSpellBookSlot(self)
                local isPassive = IsPassiveSpell(slot, _G.SpellBookFrame.bookType)
                local name = self:GetName()
                local highlightTexture = _G[name .. 'Highlight']
                if isPassive then
                    highlightTexture:SetColorTexture(1, 1, 1, 0)
                else
                    highlightTexture:SetColorTexture(1, 1, 1, .25)
                end

                local subSpellString = _G[name .. 'SubSpellName']
                local isOffSpec = self.offSpecID ~= 0 and _G.SpellBookFrame.bookType == _G.BOOKTYPE_SPELL
                subSpellString:SetTextColor(1, 1, 1)

                if slotType == 'FUTURESPELL' then
                    local level = GetSpellAvailableLevel(slot, _G.SpellBookFrame.bookType)
                    if level and level > UnitLevel('player') then
                        self.SpellName:SetTextColor(.7, .7, .7)
                        subSpellString:SetTextColor(.7, .7, .7)
                    end
                else
                    if slotType == 'SPELL' and isOffSpec then
                        subSpellString:SetTextColor(.7, .7, .7)
                    end
                end
                self.RequiredLevelString:SetTextColor(.7, .7, .7)

                local ic = _G[name .. 'IconTexture']
                if ic.bg then
                    ic.bg:SetShown(ic:IsShown())
                end

                if self.ClickBindingIconCover and self.ClickBindingIconCover:IsShown() then
                    self.SpellName:SetTextColor(.7, .7, .7)
                end
            end
        )

        _G.SpellBookSkillLineTab1:SetPoint('TOPLEFT', _G.SpellBookSideTabsFrame, 'TOPRIGHT', 2, -36)

        hooksecurefunc(
            'SpellBookFrame_UpdateSkillLineTabs',
            function()
                for i = 1, GetNumSpellTabs() do
                    local tab = _G['SpellBookSkillLineTab' .. i]
                    local nt = tab:GetNormalTexture()
                    if nt then
                        nt:SetTexCoord(unpack(C.TexCoord))
                        nt:SetInside(tab)
                    end

                    if not tab.styled then
                        tab:GetRegions():Hide()
                        tab:SetCheckedTexture(C.Assets.Textures.Button.Checked)
                        tab:GetHighlightTexture():SetColorTexture(1, 1, 1, .25)
                        F.SetBD(tab)

                        tab.styled = true
                    end
                end
            end
        )

        _G.SpellBookFrameTutorialButton.Ring:Hide()
        _G.SpellBookFrameTutorialButton:SetPoint('TOPLEFT', _G.SpellBookFrame, 'TOPLEFT', -12, 12)

        -- Professions

        local professions = {'PrimaryProfession1', 'PrimaryProfession2', 'SecondaryProfession1', 'SecondaryProfession2', 'SecondaryProfession3'}

        for i, button in pairs(professions) do
            local bu = _G[button]
            bu.professionName:SetTextColor(1, 1, 1)
            bu.missingHeader:SetTextColor(1, 1, 1)
            bu.missingText:SetTextColor(1, 1, 1)

            F.StripTextures(bu.statusBar)
            bu.statusBar:SetHeight(10)
            bu.statusBar:SetStatusBarTexture(C.Assets.Textures.Backdrop)
            bu.statusBar:GetStatusBarTexture():SetGradient('VERTICAL', 0, .6, 0, 0, .8, 0)
            bu.statusBar.rankText:SetPoint('CENTER')
            F.CreateBDFrame(bu.statusBar, .25)
            if i > 2 then
                bu.statusBar:ClearAllPoints()
                bu.statusBar:SetPoint('BOTTOMLEFT', 16, 3)
            end
        end

        local professionbuttons = {
            'PrimaryProfession1SpellButtonTop',
            'PrimaryProfession1SpellButtonBottom',
            'PrimaryProfession2SpellButtonTop',
            'PrimaryProfession2SpellButtonBottom',
            'SecondaryProfession1SpellButtonLeft',
            'SecondaryProfession1SpellButtonRight',
            'SecondaryProfession2SpellButtonLeft',
            'SecondaryProfession2SpellButtonRight',
            'SecondaryProfession3SpellButtonLeft',
            'SecondaryProfession3SpellButtonRight'
        }

        for _, button in pairs(professionbuttons) do
            local bu = _G[button]
            F.StripTextures(bu)
            bu:SetPushedTexture('')

            local icon = bu.iconTexture
            icon:ClearAllPoints()
            icon:SetPoint('TOPLEFT', 2, -2)
            icon:SetPoint('BOTTOMRIGHT', -2, 2)
            F.ReskinIcon(icon)

            bu.highlightTexture:SetAllPoints(icon)
            local check = bu:GetCheckedTexture()
            check:SetTexture(C.Assets.Textures.Button.Checked)
            check:SetAllPoints(icon)
        end

        for i = 1, 2 do
            local bu = _G['PrimaryProfession' .. i]
            _G['PrimaryProfession' .. i .. 'IconBorder']:Hide()

            bu.professionName:ClearAllPoints()
            bu.professionName:SetPoint('TOPLEFT', 100, -4)
            bu.icon:SetAlpha(1)
            bu.icon:SetDesaturated(false)
            F.ReskinIcon(bu.icon)

            local bg = F.CreateBDFrame(bu, .25)
            bg:SetPoint('TOPLEFT')
            bg:SetPoint('BOTTOMRIGHT', 0, -5)
        end

        hooksecurefunc(
            'FormatProfession',
            function(frame, index)
                if index then
                    local _, texture = GetProfessionInfo(index)

                    if frame.icon and texture then
                        frame.icon:SetTexture(texture)
                    end
                end
            end
        )

        F.CreateBDFrame(_G.SecondaryProfession1, .25)
        F.CreateBDFrame(_G.SecondaryProfession2, .25)
        F.CreateBDFrame(_G.SecondaryProfession3, .25)
        F.ReskinArrow(_G.SpellBookPrevPageButton, 'left')
        F.ReskinArrow(_G.SpellBookNextPageButton, 'right')
        _G.SpellBookPageText:SetTextColor(.8, .8, .8)

        hooksecurefunc(
            'UpdateProfessionButton',
            function(self)
                local spellIndex = self:GetID() + self:GetParent().spellOffset
                local isPassive = IsPassiveSpell(spellIndex, _G.SpellBookFrame.bookType)
                if isPassive then
                    self.highlightTexture:SetColorTexture(1, 1, 1, 0)
                else
                    self.highlightTexture:SetColorTexture(1, 1, 1, .25)
                end
                self.spellString:SetTextColor(1, 1, 1)
                self.subSpellString:SetTextColor(1, 1, 1)
            end
        )
    end
)

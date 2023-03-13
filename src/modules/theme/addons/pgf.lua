local F = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

function THEME:ReskinPGF()
    if not _G.ANDROMEDA_ADB.ReskinPremadeGroupsFilter then
        return
    end

    if not IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    local tipStyled
    hooksecurefunc(_G.PremadeGroupsFilter.Debug, 'PopupMenu_Initialize', function()
        if tipStyled then
            return
        end

        for i = 1, _G.PremadeGroupsFilterDialog:GetNumChildren() do
            local child = select(i, _G.PremadeGroupsFilterDialog:GetChildren())
            if child and child.Shadow then
                F:GetModule('Tooltip').ReskinTooltip(child)
                tipStyled = true
                break
            end
        end
    end)

    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'SetPoint', function(self, _, parent)
        if parent ~= _G.LFGListFrame then
            self:ClearAllPoints()
            self:SetPoint('TOPLEFT', _G.LFGListFrame, 'TOPRIGHT', 5, 0)
        end
    end)

    local styled
    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'Show', function(self)
        if styled then
            return
        end

        F.StripTextures(self)
        F.SetBD(self):SetAllPoints()
        F.ReskinClose(self.CloseButton)
        F.ReskinButton(self.ResetButton)
        F.ReskinButton(self.RefreshButton)
        F.ReskinDropdown(self.Difficulty.DropDown)
        F.ReskinEditbox(self.Expression)
        F.ReskinEditbox(self.Sorting.SortingExpression)

        if self.MoveableToggle then
            F.ReskinArrow(self.MoveableToggle, 'left')
            self.MoveableToggle:SetPoint('TOPLEFT', 5, -5)
        end

        local button = self.MaxMinButtonFrame

        if button.MinimizeButton then
            F.ReskinArrow(button.MinimizeButton, 'down')
            button.MinimizeButton:ClearAllPoints()
            button.MinimizeButton:SetPoint('RIGHT', self.CloseButton, 'LEFT', -3, 0)

            F.ReskinArrow(button.MaximizeButton, 'up')
            button.MaximizeButton:ClearAllPoints()
            button.MaximizeButton:SetPoint('RIGHT', self.CloseButton, 'LEFT', -3, 0)
        end

        local names = {
            'Difficulty',
            'Defeated',
            'Members',
            'Tanks',
            'Heals',
            'Dps',
            'MPRating',
            'PVPRating',
        }

        for _, name in pairs(names) do
            local frame = self[name]
            if frame then
                local check = frame.Act
                if check then
                    check:SetSize(26, 26)
                    check:SetPoint('TOPLEFT', 5, -3)
                    F.ReskinCheckbox(check)
                end

                local input = frame.Min
                if input then
                    F.ReskinEditbox(input)
                    F.ReskinEditbox(frame.Max)
                end
            end
        end

        styled = true
    end)

    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'SetSize', function(self, width, height)
        if height == 427 then
            self:SetSize(width, 428)
        end
    end)

    local button = _G.UsePFGButton or _G.UsePGFButton
    if button then
        F.ReskinCheckbox(button, true)

        button:ClearAllPoints()
        button:SetPoint('RIGHT', _G.LFGListFrame.SearchPanel.RefreshButton, 'LEFT', -40, 0)
        button:SetSize(20, 20)

        button.text:SetWidth(35)
        button.text:SetFontObject(_G.Game12Font)
    end
end

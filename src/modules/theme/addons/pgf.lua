local F = unpack(select(2, ...))
local THEME = F:GetModule('Theme')

function THEME:ReskinPGF()
    if not _G.ANDROMEDA_ADB.ReskinPremadeGroupsFilter then
        return
    end

    if not IsAddOnLoaded('PremadeGroupsFilter') then
        return
    end

    local DungeonPanel = _G.PremadeGroupsFilterDungeonPanel
    if not DungeonPanel then
        return
    end

    local ArenaPanel = _G.PremadeGroupsFilterArenaPanel
    local RBGPanel = _G.PremadeGroupsFilterRBGPanel
    local RaidPanel = _G.PremadeGroupsFilterRaidPanel
    local ExpressionPanel = _G.PremadeGroupsFilterMiniPanel
    local PGFDialog = _G.PremadeGroupsFilterDialog

    local names = { 'Difficulty', 'MPRating', 'Members', 'Tanks', 'Heals', 'DPS', 'Partyfit', 'BLFit', 'BRFit', 'Defeated', 'MatchingId', 'PvPRating' }

    local function handleGroup(panel)
        for _, name in pairs(names) do
            local frame = panel.Group[name]
            if frame then
                local check = frame.Act
                if check then
                    check:SetSize(26, 26)
                    check:SetPoint('TOPLEFT', 5, -1)
                    F.ReskinCheckbox(check)
                end
                local input = frame.Min
                if input then
                    F.ReskinEditbox(input)
                    F.ReskinEditbox(frame.Max)
                end
                if frame.DropDown then
                    F.ReskinDropdown(frame.DropDown)
                end
            end
        end

        F.ReskinEditbox(panel.Advanced.Expression)
    end

    local styled
    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'Show', function(self)
        if styled then
            return
        end
        styled = true

        F.StripTextures(self)
        F.SetBD(self):SetAllPoints()
        F.ReskinClose(self.CloseButton)
        F.ReskinButton(self.ResetButton)
        F.ReskinButton(self.RefreshButton)

        F.ReskinInput(ExpressionPanel.Advanced.Expression)
        F.ReskinInput(ExpressionPanel.Sorting.Expression)

        local button = self.MaxMinButtonFrame

        if button.MinimizeButton then
            F.ReskinArrow(button.MinimizeButton, 'down')
            button.MinimizeButton:ClearAllPoints()
            button.MinimizeButton:SetPoint('RIGHT', self.CloseButton, 'LEFT', -3, 0)

            F.ReskinArrow(button.MaximizeButton, 'up')
            button.MaximizeButton:ClearAllPoints()
            button.MaximizeButton:SetPoint('RIGHT', self.CloseButton, 'LEFT', -3, 0)
        end

        handleGroup(RaidPanel)
        handleGroup(DungeonPanel)
        handleGroup(ArenaPanel)
        handleGroup(RBGPanel)

        for i = 1, 8 do
            local dungeon = DungeonPanel.Dungeons['Dungeon' .. i]
            local check = dungeon and dungeon.Act
            if check then
                check:SetSize(26, 26)
                check:SetPoint('TOPLEFT', 5, -1)
                F.ReskinCheckbox(check)
            end
        end

        styled = true
    end)

    hooksecurefunc(_G.PremadeGroupsFilterDialog, 'ResetPosition', function(self)
        self:ClearAllPoints()
        self:SetPoint('TOPLEFT', PVEFrame, 'TOPRIGHT', 2, 0)
    end)

    local button = _G.UsePGFButton
    if button then
        F.ReskinCheckbox(button, true)

        button:ClearAllPoints()
        button:SetPoint('RIGHT', _G.LFGListFrame.SearchPanel.RefreshButton, 'LEFT', -40, 0)
        button:SetSize(20, 20)

        button.text:SetWidth(35)
        button.text:SetFontObject(_G.Game12Font)
    end
end

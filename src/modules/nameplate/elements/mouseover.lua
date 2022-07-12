local F, C = unpack(select(2, ...))
local NAMEPLATE = F:GetModule('Nameplate')

function NAMEPLATE:IsMouseoverUnit()
    if not self or not self.unit then
        return
    end

    if self:IsVisible() and UnitExists('mouseover') then
        return UnitIsUnit('mouseover', self.unit)
    end
    return false
end

function NAMEPLATE:HighlightOnUpdate(elapsed)
    self.elapsed = (self.elapsed or 0) + elapsed
    if self.elapsed > 0.1 then
        if not NAMEPLATE.IsMouseoverUnit(self.__owner) then
            self:Hide()
        end
        self.elapsed = 0
    end
end

function NAMEPLATE:HighlightOnHide()
    self.__owner.HighlightIndicator:Hide()
end

function NAMEPLATE:UpdateMouseoverShown()
    if not self or not self.unit then
        return
    end

    if self:IsShown() and UnitIsUnit('mouseover', self.unit) then
        self.HighlightIndicator:Show()
        self.HighlightUpdater:Show()
    else
        self.HighlightUpdater:Hide()
    end
end

function NAMEPLATE:CreateMouseoverIndicator(self)
    local highlight = CreateFrame('Frame', nil, self.Health)
    highlight:SetAllPoints(self)
    highlight:Hide()
    local texture = highlight:CreateTexture(nil, 'ARTWORK')
    texture:SetAllPoints()
    texture:SetColorTexture(1, 1, 1, 0.25)

    self:RegisterEvent('UPDATE_MOUSEOVER_UNIT', NAMEPLATE.UpdateMouseoverShown, true)

    local updater = CreateFrame('Frame', nil, self)
    updater.__owner = self
    updater:SetScript('OnUpdate', NAMEPLATE.HighlightOnUpdate)
    updater:HookScript('OnHide', NAMEPLATE.HighlightOnHide)

    self.HighlightIndicator = highlight
    self.HighlightUpdater = updater
end
